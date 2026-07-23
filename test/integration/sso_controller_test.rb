# test/controllers/sso_controller_test.rb
require "test_helper"

class SsoControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secret = "test_sso_secret_key_12345"
    @role = Role.find_or_create_by!(name: "Member")
  end

  test "should redirect to login when credentials secret is nil or blank" do
    token = generate_jwt({ email: "test@example.com" }, @secret)

    # Temporarily stub rails_sso_secret to return nil inside the block
    Rails.application.credentials.stub(:rails_sso_secret, nil) do
      get sso_login_url(token: token)
    end

    assert_redirected_to login_path
    assert_equal "SSO system configuration error.", flash[:alert]
  end

  test "should create a new user when email does not exist (JIT) and log them in" do
    payload = { email: "jane.doe@example.com", name: "Jane Doe" }
    token = generate_jwt(payload, @secret)

    # Stub the secret key for a successful decode
    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      assert_difference("User.count", 1) do
        get sso_login_url(token: token)
      end
    end

    assert_redirected_to directory_index_path
    assert_equal "Successfully authenticated from Drupal!", flash[:notice]
  end

  private

  def generate_jwt(payload, secret)
    JWT.encode(payload, secret, "HS256")
  end
end
