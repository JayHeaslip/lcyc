require 'uri'
require 'net/http'
require 'openssl'
require "base64"
require 'json'

class QuickbooksController < ApplicationController

  def connect
    redirect_uri = "http://localhost:3000/quickbooks/new"
    Quickbooks.sandbox_mode = true
    environment = 'sandbox'

    client_id = Rails.application.secrets.OAUTH_CONSUMER_KEY
    client_secret = Rails.application.secrets.OAUTH_CONSUMER_SECRET

    scopes = [
      IntuitOAuth::Scopes::ACCOUNTING
    ]

    qb_oauth2_consumer = IntuitOAuth::Client.new(client_id, client_secret, redirect_uri, environment)
    authorizationCodeUrl = qb_oauth2_consumer.code.get_auth_uri(scopes)
    redirect_to authorizationCodeUrl
  end

  def new
    @exchangeURL = 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer'
    @code =params[:code]
    @realmID = params[:realmId]
    result = exchange_code_for_token
    @result = result
    params[:refresh_token] = result["refresh_token"]
    params[:expires_in] = result["expires_in"]
    params[:x_refresh_token_expires_in] = result["x_refresh_token_expires_in"]
    params[:access_token] = result["access_token"]
    params[:host_uri] = @hostURL.to_s
  end

  def update_members
  end

  def generate_invoices
  end

  def exchange_code_for_token
    url = URI(@exchangeURL)
    grant_type = 'authorization_code'
    redirect_uri = "http://localhost:3000/quickbooks/new"
   
    queryparams = {
      'code' => @code.to_s,
      'grant_type' => grant_type.to_s,
      'redirect_uri' => redirect_uri.to_s
    }
    client_id = Rails.application.secrets.OAUTH_CONSUMER_KEY
    client_secret = Rails.application.secrets.OAUTH_CONSUMER_SECRET
    header_value = "Basic " + Base64.strict_encode64(client_id.to_s + ":" + client_secret.to_s)
    headers = {
      'Content-type' => "application/x-www-form-urlencoded",
      'Accept' => "application/json",
      'Authorization' => header_value
    }
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # TO debug, enable the below Line
    http.set_debug_output($stdout)
    req = Net::HTTP::Post.new(url, headers)
    req.set_form_data(queryparams)
    logger.info req
    response = http.request(req)
    hash_response = JSON.parse(response.body)
    return hash_response
  end
  
end
