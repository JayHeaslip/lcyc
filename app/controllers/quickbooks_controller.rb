require 'uri'
require 'net/http'
require 'openssl'
require "base64"
require 'json'

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
    service = Quickbooks::Service::Customer.new
    logger.info session[:access_token].class
    
    service.company_id = session[:realmID]
    service.access_token = session[:access_token]
    logger.info service
    @customers = service.query()
    
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
  
end
