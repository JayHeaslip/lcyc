require "uri"
require "net/http"
require "openssl"
require "base64"
require "json"

class QuickbooksController < ApplicationController
  # remove leading/trailing blanks for membership data going to quickbooks
  def cleanup
    Membership.billed_members.each do |m|
      @update = false
      m.MailingName = strip(m.MailingName)
      m.StreetAddress = strip(m.StreetAddress)
      m.City = strip(m.City)
      m.State = strip(m.State)
      m.Zip = strip(m.Zip)
      m.save if @update
    end
  end

  def connect
    session[:state] = SecureRandom.uuid
    session[:qb_oauth_processed] = false
    client = oauth2_client
    redirect_to client.authorization_uri(scope: "com.intuit.quickbooks.accounting", state: session[:state]), allow_other_host: true
  end

  def new
    # :nocov:
    if params[:code].present?
      if session[:qb_oauth_processed]
        flash[:notice] = "QuickBooks is already connected."
        return redirect_to root_path
      end

      state = params[:state]
      error = params[:error]
      code = params[:code]
      if state == session[:state]
        client = oauth2_client
        client.authorization_code = code
        if (resp = client.access_token!)
          session[:refresh_token] = resp.refresh_token
          session[:access_token] = resp.access_token
          session[:realm_id] = params[:realmId]
          session[:qb_oauth_processed] = true
        else
          "Something went wrong. Try the process again"
        end
      else
        "Error: #{error}"
      end
    end
    # :nocov:
  end

  def update_members
    # :nocov:
    if (access_token = session[:access_token])
      QboApi.production = (Rails.env == "production")
      QboApi.minor_version = 75
      @api = QboApi.new(access_token: access_token, realm_id: session[:realm_id])
      members = Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
      qb_members = @api.all(:customer)
      @existing_qbo_members = {}
      @deleted_qbo_members = []
      members.each do |m|
        @existing_qbo_members[m.MailingName] = false
      end

      # for each membership, update the data in QBO
      qb_members.each do |qbm|
        display_name = qbm["DisplayName"]
        m = Membership.members.find_by_MailingName(display_name)
        # look in accepted if not found
        m = Membership.accepted.find_by_MailingName(display_name) if m.nil?
        update_member(qbm, m, display_name)
      end

      # add new members
      count = 0
      errors = []
      @existing_qbo_members.each do |k, v|
        unless v # create the member in QBO
          m = Membership.find_by_MailingName(k)
          member = {
            DisplayName: k,
            BillAddr: { Line1: m.StreetAddress,
                        City: m.City,
                        CountrySubDivisionCode: m.State,
                        PostalCode: m.Zip },
            PrimaryEmailAddr: { Address: m.primary_email }
          }
          logger.info "Creating #{k}"
          begin
            response = @api.create(:customer, payload: member)
          rescue QboApi::BadRequest => e
            errors << e.message
          end
          count += 1
          if (count % 20) == 0
            sleep(40)
          end
        end
      end
      flash[:alert] = errors.join("\n") if errors.any?
    else
      flash[:alert] = "Please connect to quickbooks."
      redirect_to root_url
    end
    # :nocov:
  end

  def invoices
    @test = true
  end

  def generate_invoices
    # :nocov:
    if (access_token = session[:access_token]).blank?
      flash[:alert] = "Please connect to QuickBooks."
      return redirect_to invoices_quickbooks_path
    end

    QboApi.production = (Rails.env == "production")
    QboApi.minor_version = 75
    @api = QboApi.new(access_token: access_token, realm_id: session[:realm_id])

    members = if params[:test]
                [ Membership.find(64), Membership.find(345) ]
    else
                Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
    end

    payload = { "BatchItemRequest": [] }
    batch_id_counter = 1
    total_invoices_created = 0
    failed_customers = []
    batch_errors = []
    Membership.reset_flash_message

    begin
      members.each do |membership|  # Uses batch loading to avoid N+1 and memory issues
        logger.info "Processing invoice for: #{membership.MailingName}"

        # Step 1: Find or handle missing QuickBooks customer
        customer_id = find_or_log_customer_id(membership, failed_customers)
        next unless customer_id  # Skip if customer not found in QBO

        # Step 2: Build invoice
        invoice = build_invoice(membership, customer_id, params[:test])

        # Step 3: Add to current batch
        payload[:BatchItemRequest] << {
          bId: "bid#{batch_id_counter}",
          operation: "create",
          Invoice: invoice
        }

        batch_id_counter += 1

        # Step 4: Send batch when we hit 30 items (QBO batch limit is 30)
        if payload[:BatchItemRequest].size == 30
          result = send_batch_and_reset!(payload)
          total_invoices_created += result[:successful]
          batch_errors.concat(result[:errors])
          payload[:BatchItemRequest] = []  # Reset for next batch
        end
      end

      # Step 5: Send any remaining invoices in the final batch
      if payload[:BatchItemRequest].any?
        result = send_batch_and_reset!(payload)
        total_invoices_created += result[:successful]
        batch_errors.concat(result[:errors])
      end

      # Final success message
      flash[:notice] = "Successfully created #{total_invoices_created} #{'invoice'.pluralize(total_invoices_created)}."

      flash[:error] = Membership.flash_message if Membership.flash_message != ""

      if batch_errors.any?
        alerts = [ "Some invoices failed to create: #{batch_errors.size} had errors, check the logs" ]
        logger.error batch_errors
      end

      if failed_customers.any?
        alerts ||= []
        alerts << "Warning: Skipped #{failed_customers.size} members because their QuickBooks customer was not found, check the logs"
        logger.error failed_customers
      end
      flash[:alerts] = alerts.join("\n") if alerts

      redirect_to root_url
      # :nocov:
    end
  end

  private

  def find_or_log_customer_id(membership, failed_customers)
    display_name = membership.MailingName
    begin
      response = @api.get(:customer, [ "DisplayName", display_name ])
      response["Id"]
    rescue QboApi::NotFound
      failed_customers << [ display_name, membership.id ]
      logger.warn "Customer not found in QuickBooks: #{display_name} (Membership ##{membership.id})"
      nil
    rescue QboApi::BadRequest => e
      failed_customers << [ display_name, membership.id ]
      logger.warn "Bad request for customer #{display_name}: #{e.message}"
      nil
    end
  end

  def build_invoice(membership, customer_id, test_mode)
    invoice = {
      CustomerRef: { value: customer_id },
      AllowOnlineACHPayment: true,
      DueDate: "#{Time.now.year}-12-31",
      BillEmail: { Address: membership.primary_email },
      BillEmailCc: { Address: membership.cc_email }
    }
    invoice["Line"] = generate_line_items(membership, params[:test])
    invoice
  end

  def send_batch_and_reset!(payload)
    return { successful: 0, errors: [] } if payload[:BatchItemRequest].empty?

    begin
      response = @api.batch(payload)
      logger.info "Batch response: #{response.inspect}"

      batch_responses = response["BatchItemResponse"]

      successful = batch_responses.count { |item| item["Invoice"] && !item["Fault"] }

      errors = batch_responses.map do |item|
        next unless item["Fault"]

        fault = item["Fault"]
        error_msg = fault["Message"] || "Unknown error"
        detail    = fault.dig("Detail") || ""
        "Failed (#{item['bId']}): #{error_msg}#{detail.present? ? " - #{detail}" : ""}"
        end.compact

      { successful: successful, errors: errors }

    rescue QboApi::Error => e
     logger.error "Batch failed entirely: #{e.message}"
     { successful: 0, errors: [ "Batch failed: #{e.message}" ] }
    end
  end

  def strip(str)
    (str != str.strip) ? @update = true && str.strip : str
  end

  def oauth2_client
    # :nocov:
    if Rails.env == "development"
      client_id = Rails.application.credentials.development.OAUTH_CONSUMER_KEY
      client_secret = Rails.application.credentials.development.OAUTH_CONSUMER_SECRET
      redirect_uri = Rails.application.credentials.development.REDIRECT_URI
    elsif Rails.env == "staging"
      client_id = Rails.application.credentials.staging.OAUTH_CONSUMER_KEY
      client_secret = Rails.application.credentials.staging.OAUTH_CONSUMER_SECRET
      redirect_uri = Rails.application.credentials.staging.REDIRECT_URI
    else
      client_id = Rails.application.credentials.production.OAUTH_CONSUMER_KEY
      client_secret = Rails.application.credentials.production.OAUTH_CONSUMER_SECRET
      redirect_uri = Rails.application.credentials.production.REDIRECT_URI
    end
    logger.info "redirect uri is #{redirect_uri}"

    Rack::OAuth2::Client.new(
      identifier: client_id,
      secret: client_secret,
      redirect_uri: redirect_uri,
      authorization_endpoint: "https://appcenter.intuit.com/connect/oauth2",
      token_endpoint: "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
    )
    # :nocov:
  end

  def update_member(qbm, m, display_name)
    # :nocov:
    if m # update a member
      @existing_qbo_members[display_name] = true
      update = false
      if qbm["PrimaryEmailAddr"] &&
          qbm["PrimaryEmailAddr"]["Address"] != m.primary_email
        update = true
        logger.info "email changed"
      elsif update_address(qbm, m)
        logger.info "address changed"
        update = true
      end
      if update
        logger.info "Updating QBO info for #{display_name}"
        member = {
          DisplayName: display_name,
          BillAddr: { Line1: m.StreetAddress,
                     City: m.City,
                     CountrySubDivisionCode: m.State,
                     PostalCode: m.Zip },
          PrimaryEmailAddr: { Address: m.primary_email }
        }
        @api.update(:customer, id: qbm["Id"], payload: member)
      end
    else # delete from QBO, no longer in membership db
      logger.info "deleting #{display_name}"
      @deleted_qbo_members << display_name
      @api.deactivate(:customer, id: qbm["Id"])
    end
    # :nocov:
  end

  def update_address(qbm, m)
    # :nocov:
    if qbm["BillAddr"].nil?
      return true
    elsif qbm["BillAddr"]["Line1"] != m.StreetAddress
      return true
    elsif qbm["BillAddr"]["City"] != m.City
      return true
    elsif qbm["BillAddr"]["CountrySubDivisionCode"] != m.State
      return true
    elsif qbm["BillAddr"]["PostalCode"] != m.Zip
      return true
    end
    false
    # :nocov:
  end

  def generate_line_items(m, test)
    # :nocov:
    dues = Membership.dues(m) || 0
    line_items = []
    mooring_fee = m.calculate_mooring_fee
    mooring_replacement_fee = m.calculate_mooring_replacement_fee
    drysail_fee = m.calculate_drysail_fee
    initiation_due = m.calculate_initiation_installment
    docks_assessment = m.calculate_docks_assessment

    # need to query Items to get value & name (Id & Name)
    if dues != 0
      dues = 5 if test
      dues_value = @api.get(:item, [ "Name", "Dues" ])["Id"]
      line_items << {
        Amount: dues,
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: {
            value: dues_value,
            name: "Dues"
          }
        }
      }
    end
    if mooring_fee != 0
      mooring_fee = 6 if test
      mooring_fee_value = @api.get(:item, [ "Name", "Mooring Fee" ])["Id"]
      line_items << {
        Amount: mooring_fee,
        Description: "Mooring ##{m.mooring&.id}",
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: {
            value: mooring_fee_value,
            name: "Mooring Fee"
          }
        }
      }
    end
    if mooring_replacement_fee != 0
      mooring_replacement_fee = 7 if test
      mooring_replacement_fee_value = @api.get(:item, [ "Name", "Mooring Replacement Fee" ])["Id"]
      line_items << {
        Amount: mooring_replacement_fee,
        Description: "Mooring ##{m.mooring&.id}",
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: {
            value: mooring_replacement_fee_value,
            name: "Mooring Replacement Fee"
          }
        }
      }
    end
    if drysail_fee != 0
      drysail_fee = 8 if test
      drysail_value = @api.get(:item, [ "Name", "Drysail Fee" ])["Id"]
      line_items << {
        Amount: drysail_fee,
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: {
            value: drysail_value,
            name: "Drysail Fee"
          }
        }
      }
    end
    if initiation_due != 0
      initiation_due = 9 if test
      initiation_value = @api.get(:item, [ "Name", "Initiation Installment" ])["Id"]
      line_items << {
        Amount: initiation_due,
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: {
            value: initiation_value,
            name: "Initiation Installment"
          }
        }
      }
    end

    if docks_assessment != 0
      docks_assessment_value = @api.get(:item, [ "Name", "Docks Assessment" ])["Id"]
      line_items << {
        Amount: docks_assessment,
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: {
            value: docks_assessment_value,
            name: "Docks Assessment"
          }
        }
      }
    end

    line_items
    # :nocov:
  end
end
