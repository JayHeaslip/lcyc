# config/initializers/quickbooks.rb
require "rack/oauth2"
require "qbo_api"

# Pull credentials dynamically based on the current Rails environment
env_credentials = Rails.application.credentials.dig(Rails.env.to_sym) || {}

client_id     = env_credentials[:OAUTH_CONSUMER_KEY]
client_secret = env_credentials[:OAUTH_CONSUMER_SECRET]

# Configure qbo_api mode: false means Sandbox, true means Production
QboApi.production = Rails.env.production?


# Define the global rack-oauth2 client
::QB_OAUTH2_CONSUMER = Rack::OAuth2::Client.new(
  identifier: client_id,
  secret: client_secret,
  authorization_endpoint: "https://appcenter.intuit.com/connect/oauth2",
  token_endpoint: "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
)
