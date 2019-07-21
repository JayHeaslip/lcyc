require 'uri'
require 'net/http'
require 'openssl'
require "base64"
require 'json'
require 'pp'

class QuickbooksController < ApplicationController

  def connect

    session[:state] = SecureRandom.uuid

    client = oauth2_client
    redirect_to client.authorization_uri(scope: 'com.intuit.quickbooks.accounting', state: session[:state])
  end

  def new
    state = params[:state]
    error = params[:error]
    code = params[:code]
    if state == session[:state]
      client = oauth2_client
      client.authorization_code = code
      if resp = client.access_token!
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
    if access_token = session[:access_token]
      @api = QboApi.new(access_token: access_token, realm_id: session[:realm_id])
      members = Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
      qb_members = @api.all(:customer)
      @existing_qbo_members = {}
      members.each do |m|
        @existing_qbo_members[m.MailingName] = false
      end

      # for each membership, update the data in QBO
      qb_members.each do |qbm|
        display_name = qbm['DisplayName']
        m = Membership.find_by_MailingName(display_name)
        logger.info "looking up #{display_name}"
        logger.info "m nil? #{m.nil?}"
        logger.info m
        update_member(qbm,m,display_name)
      end

      # add new members
      count = 0
      @existing_qbo_members.each do |k,v|
        unless v # create the member in QBO
          m = Membership.find_by_MailingName(k)
          member_email = m.people.where('MemberType = "Member"').first.EmailAddress
          member = {
            "DisplayName": k,
                    "BillAddr": { "Line1": m.StreetAddress,
                                  "City":  m.City,
                                  "CountrySubDivisionCode": m.State,
                                  "PostalCode": m.Zip
                                },
                    "PrimaryEmailAddr": { "Address": member_email }
          }
          logger.info "Creating #{k}"
          response = @api.create(:customer, payload: member)
          count += 1
          if (count % 20) == 0
            sleep(40)
          end
        end
      end
      
    end
    
  end

  def generate_invoices
  end

  def oauth2_client
    client_id = Rails.application.secrets.OAUTH_CONSUMER_KEY
    client_secret = Rails.application.secrets.OAUTH_CONSUMER_SECRET
    redirect_uri = Rails.application.secrets.REDIRECT_URI
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
    else # delete from QBO, no longer in membership db
      logger.info "deleting #{display_name}"
      response = @api.deactivate(:customer, id: qbm['Id'])
    end
  end
  
end
