# test/controllers/sso_controller_test.rb
require "test_helper"

class SsoControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secret = "test_sso_secret_key_12345"
    @role = Role.find_or_create_by!(name: "Member")
  end

  # --- 1. MISSING TOKEN & CONFIGURATION ---

  test "should redirect to login when token is missing or blank" do
    get sso_login_url(token: "")

    assert_redirected_to login_path
    assert_equal "Missing authentication token.", flash[:alert]
  end

  test "should redirect to login when credentials secret is nil or blank" do
    token = generate_jwt({ email: "test@example.com" }, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, nil) do
      get sso_login_url(token: token)
    end

    assert_redirected_to login_path
    assert_equal "SSO system configuration error.", flash[:alert]
  end

  # --- 2. JIT PROVISIONING BRANCHES ---

  test "should create a new user with full name (JIT) and log them in" do
    payload = { email: "jane.doe@example.com", name: "Jane Doe" }
    token = generate_jwt(payload, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      assert_difference("User.count", 1) do
        get sso_login_url(token: token)
      end
    end

    user = User.find_by!(email: "jane.doe@example.com")
    assert_equal "Jane", user.firstname
    assert_equal "Doe", user.lastname
    assert_equal @role, user.role

    assert_redirected_to directory_index_path
    assert_equal "Successfully authenticated from Drupal!", flash[:notice]
  end

  test "should handle single-word names correctly when provisioning user" do
    payload = { email: "cher@example.com", name: "Cher" }
    token = generate_jwt(payload, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      assert_difference("User.count", 1) do
        get sso_login_url(token: token)
      end
    end

    user = User.find_by!(email: "cher@example.com")
    assert_equal "Cher", user.firstname
    assert_equal "Cher", user.lastname # Fallback branch: parts[1] || parts[0]
  end

  test "should assign default names when name is missing from payload" do
    payload = { email: "noname@example.com" }
    token = generate_jwt(payload, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      assert_difference("User.count", 1) do
        get sso_login_url(token: token)
      end
    end

    user = User.find_by!(email: "noname@example.com")
    assert_equal "SSO", user.firstname
    assert_equal "User", user.lastname
  end

  test "should authenticate existing user without creating a new record" do
    existing_user = User.create!(
      email: "existing@example.com",
      firstname: "Existing",
      lastname: "User",
      password: 'abcdefg',
      role: @role
    )

    payload = { email: existing_user.email, name: "Existing User" }
    token = generate_jwt(payload, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      assert_no_difference("User.count") do
        get sso_login_url(token: token)
      end
    end

    assert_redirected_to directory_index_path
    assert_equal "Successfully authenticated from Drupal!", flash[:notice]
  end

  # --- 3. JWT EXCEPTIONS & EXPIRATION ---

  test "should redirect to root when token signature is expired" do
    # Payload expired 10 minutes ago (beyond the 180s leeway)
    payload = { email: "expired@example.com", exp: 10.minutes.ago.to_i }
    token = generate_jwt(payload, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      get sso_login_url(token: token)
    end

    assert_redirected_to root_path
    assert_equal "Expired link.", flash[:alert]
  end

  test "should allow tokens within the 180-second leeway window" do
    # Payload expired 2 minutes ago (within 180s leeway)
    payload = { email: "leeway@example.com", exp: 2.minutes.ago.to_i }
    token = generate_jwt(payload, @secret)

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      assert_difference("User.count", 1) do
        get sso_login_url(token: token)
      end
    end

    assert_redirected_to directory_index_path
  end

  test "should redirect to root on decode error (invalid key or tampered token)" do
    payload = { email: "hacker@example.com" }
    token = generate_jwt(payload, "wrong_secret_key")

    Rails.application.credentials.stub(:rails_sso_secret, @secret) do
      get sso_login_url(token: token)
    end

    assert_redirected_to root_path
    assert_equal "Invalid token.", flash[:alert]
  end

  private

  def generate_jwt(payload, secret)
    JWT.encode(payload, secret, "HS256")
  end
end
