require "uri"
require "net/http"
require "openssl"
require "base64"
require "json"

class QuickbooksController < ApplicationController

  before_action :check_qb_connection, only: [:invoices, :generate_invoices]
  before_action :cleanup, only: [:invoices]


  def connect
    session[:state] = SecureRandom.uuid
    client = QuickbooksConfig.new.oauth2_client
    redirect_to client.authorization_uri(
                  scope: "com.intuit.quickbooks.accounting", 
                  state: session[:state]
                ), allow_other_host: true
  end

  def new
    # :nocov:
    if params[:code].present?
      state = params[:state]
      error = params[:error]
      code = params[:code]
      
      if state == session[:state]
        client = QuickbooksConfig.new.oauth2_client
        client.authorization_code = code
        
        # Exchange code for access token
        if (resp = client.access_token!)
          # --- MODIFICATION HERE: Save to DB instead of session ---
          config = QuickbooksConfig.first_or_initialize
          config.update!(
            access_token: resp.access_token,
            refresh_token: resp.refresh_token,
            realm_id: params[:realmId],
            access_token_expires_at: Time.now + resp.expires_in.seconds
          )
          
          flash[:notice] = "QuickBooks connected successfully."
          redirect_to invoices_path
        else
          flash[:alert] = "Something went wrong. Try the process again."
          redirect_to root_path
        end
      else
        flash[:alert] = "Error: #{error}"
        redirect_to root_path
      end
    end
    # :nocov:
  end

  def invoices
    @test = true
  end

  def generate_invoices
    UpdateMembersJob.perform_later
      .then {InvoiceBatchManagerJob.perform_later(params[:test]) }
    flash[:notice] = "Generating invoices, check quickbooks in about 15 minutes"
    redirect_to root_path
  end

  private

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

  def check_qb_connection
    config = QuickbooksConfig.first
    if config.nil? || config.access_token.blank?
      flash[:alert] = "Please connect to QuickBooks first."
      redirect_to connect_quickbooks_path # Redirect to start OAuth flow
    end
  end

  def strip(str)
    (str != str.strip) ? (@update = true && str.strip) : str
  end

end
