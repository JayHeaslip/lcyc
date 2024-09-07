require "uri"
require "net/http"
require "openssl"
require "base64"
require "json"

class QuickbooksController < ApplicationController
  # remove leading/trailing blanks for membership data going to quickbooks
  def cleanup
    members = Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
    members.each do |m|
      update = false
      if m.MailingName != m.MailingName.strip
        update = true
        m.MailingName = m.MailingName.strip
      elsif m.StreetAddress != m.StreetAddress.strip
        update = true
        m.StreetAddress = m.StreetAddress.strip
      elsif m.City != m.City.strip
        update = true
        m.City = m.City.strip
      elsif m.State != m.State.strip
        update = true
        m.State = m.State.strip
      elsif m.Zip != m.Zip.strip
        update = true
        m.Zip = m.Zip.strip
      end
      m.save if update
    end
  end

  def connect
    session[:state] = SecureRandom.uuid

    client = oauth2_client
    redirect_to client.authorization_uri(scope: "com.intuit.quickbooks.accounting", state: session[:state]), allow_other_host: true
  end

  def new
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
      else
        "Something went wrong. Try the process again"
      end
    else
      "Error: #{error}"
    end
  end

  def update_members
    if (access_token = session[:access_token])
      QboApi.production = (Rails.env == "production")
      QboApi.minor_version = 8
      @api = QboApi.new(access_token: access_token, realm_id: session[:realm_id])
      members = Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
      qb_members = @api.all(:customer)
      @existing_qbo_members = {}
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
          @api.create(:customer, payload: member)
          count += 1
          if (count % 20) == 0
            sleep(40)
          end
        end
      end
    else
      flash[:alert] = "Please connect to quickbooks."
      redirect_to root_url
    end
  end

  def invoices
    @test = true
  end

  def generate_invoices
    if (access_token = session[:access_token])
      QboApi.production = (Rails.env == "production")
      QboApi.minor_version = 8
      @api = QboApi.new(access_token: access_token, realm_id: session[:realm_id])
      members = if params[:test]
        [ Membership.find(64), Membership.find(345) ]
      else
        Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
      end
      count = 0
      members.each do |m|
        logger.info "mailing name: #{m.MailingName}"
        qbm = @api.get(:customer, [ "DisplayName", m.MailingName ])
        logger.info "prefer #{m.prefer_partner_email}"
        logger.info "primary email #{m.primary_email}"
        logger.info " cc email #{m.cc_email}"
        invoice = {
          CustomerRef: { value: qbm["Id"] },
          AllowOnlineACHPayment: true,
          BillEmail: { Address: m.primary_email },
          BillEmailCc: { Address: m.cc_email },
          DueDate: "#{Time.now.year}-12-31"
        }
        invoice["Line"] = generate_line_items(m, params[:test])
        logger.info invoice
        @api.create(:invoice, payload: invoice)
        count += 1
        if (count % 20) == 0
          sleep(40)
        end
      end
      flash[:notice] = "Created #{count} invoices."
      redirect_to root_url
    else
      flash[:alert] = "Please connect to quickbooks."
      redirect_to invoices_quickbooks_path
    end
  end

  private

  def oauth2_client
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
  end

  def update_member(qbm, m, display_name)
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
      @api.deactivate(:customer, id: qbm["Id"])
    end
  end

  def update_address(qbm, m)
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
  end

  def generate_line_items(m, test)
    dues = Membership.dues(m) || 0
    mooring_fee = m.calculate_mooring_fee
    mooring_replacement_fee = m.calculate_mooring_replacement_fee
    drysail_fee = m.calculate_drysail_fee
    initiation_due = m.calculate_initiation_installment

    # need to query Items to get value & name (Id & Name)
    line_items = []
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

    line_items
  end
end
