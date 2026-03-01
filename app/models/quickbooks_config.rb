class QuickbooksConfig < ApplicationRecord
  encrypts :access_token, :refresh_token

  # This is the "magic" method. Call config.api_client, and it handles everything.
  def api_client
    refresh_if_expired!
    QboApi.new(
      access_token: access_token,
      realm_id: realm_id
    )
  end

  def refresh_if_expired!
    # Refresh if token expires within the next 5 minutes
    if access_token_expires_at < 5.minutes.from_now
      client = oauth2_client
      client.refresh_token = refresh_token

      if (resp = client.access_token!)
        update!(
          access_token: resp.access_token,
          refresh_token: resp.refresh_token,
          access_token_expires_at: Time.now + resp.expires_in.seconds
        )
      end
    end
  end

  def oauth2_client
    # Dynamically pulls from credentials based on Rails.env (development, staging, production)
    creds = Rails.application.credentials[Rails.env.to_sym]

    Rack::OAuth2::Client.new(
      identifier: creds[:OAUTH_CONSUMER_KEY],
      secret:     creds[:OAUTH_CONSUMER_SECRET],
      redirect_uri: creds[:REDIRECT_URI],
      authorization_endpoint: "https://appcenter.intuit.com/connect/oauth2",
      token_endpoint: "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
    )
  end
end
