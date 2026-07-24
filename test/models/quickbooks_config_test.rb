require "test_helper"

class QuickbooksConfigTest < ActiveSupport::TestCase
  setup do
    @config = QuickbooksConfig.new(
      realm_id: "123456789",
      access_token: "valid_access_token",
      refresh_token: "valid_refresh_token",
      access_token_expires_at: 1.hour.from_now
    )
  end

  # --- #api_client Tests ---

  test "api_client checks expiration and returns a configured QboApi instance" do
    # Verify that refresh_if_expired! is called
    @config.stub :refresh_if_expired!, true do
      api = @config.api_client

      assert_instance_of QboApi, api
      assert_equal "valid_access_token", api.access_token
      assert_equal "123456789", api.realm_id
    end
  end

  # --- #refresh_if_expired! Tests ---

  test "refresh_if_expired! does nothing if token is still valid (expires in > 5 minutes)" do
    # Ensure no OAuth client is ever built if the token isn't expiring soon
    @config.stub :oauth2_client, -> { raise "Should not be called" } do
      assert_no_changes -> { @config.access_token } do
        @config.refresh_if_expired!
      end
    end
  end

  test "refresh_if_expired! refreshes tokens when token expires within 5 minutes" do
    # Expiring in 2 minutes triggers the refresh
    @config.access_token_expires_at = 2.minutes.from_now

    # Mock response object from Rack::OAuth2
    mock_response = Minitest::Mock.new
    mock_response.expect :access_token, "new_access_token"
    mock_response.expect :refresh_token, "new_refresh_token"
    mock_response.expect :expires_in, 3600

    # Mock OAuth2 client
    mock_oauth_client = Minitest::Mock.new
    mock_oauth_client.expect :refresh_token=, nil, ["valid_refresh_token"]
    mock_oauth_client.expect :access_token!, mock_response

    @config.stub :oauth2_client, mock_oauth_client do
      travel_to Time.current do
        @config.refresh_if_expired!

        assert_equal "new_access_token", @config.access_token
        assert_equal "new_refresh_token", @config.refresh_token
        assert_equal Time.current + 3600.seconds, @config.access_token_expires_at
      end
    end

    mock_response.verify
    mock_oauth_client.verify
  end

  # --- #oauth2_client Tests ---

  test "oauth2_client configures Rack::OAuth2::Client with credentials" do
    client = @config.oauth2_client

    assert_instance_of Rack::OAuth2::Client, client
    assert_equal "https://appcenter.intuit.com/connect/oauth2", client.authorization_endpoint
    assert_equal "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer", client.token_endpoint
  end
end
