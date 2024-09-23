require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_user = User.create!(firstname: "Jim", lastname: "Bob", email: "confirmed_user@example.com",
      password: "password", password_confirmation: "password", confirmed_at: 1.week.ago, role: roles(:member))
    @unconfirmed_user = User.create!(firstname: "Jim", lastname: "Bob", email: "unconfirmed_user@example.com",
      password: "password", password_confirmation: "password", confirmed_at: nil, role: roles(:member))
  end

  test "should get edit" do
    password_reset_token = @confirmed_user.generate_password_reset_token

    get edit_password_path(password_reset_token)
    assert_response :ok
  end

  test "should display form to update password" do
    @user = users(:three)
    login_as(@user, "passwor3")

    get change_password_path
    assert_response :ok
  end

  test "should not update password if current_password is incorrect" do
    @user = users(:three)
    login_as(@user, "passwor3")

    post change_password_path, params: {
      user: {
        current_password: "wrong_password",
        password: "new_password",
        password_confirmation: "new_password"
      }
    }
    assert_response :unprocessable_entity
  end

  test "should update password if current_password is correct" do
    @user = users(:three)
    login_as(@user, "passwor3")

    get change_password_path, headers: { HTTP_REFERER: root_url }
    post change_password_path, params: {
      current_password: "passwor3",
      password: "new_password",
      password_confirmation: "new_password"
    }
    assert_redirected_to root_path
    assert_equal flash[:success], "Password updated"
  end

  test "should not update password if passwords don't match" do
    @user = users(:three)
    login_as(@user, "passwor3")

    post change_password_path, params: {
      current_password: "passwor3",
      password: "new_password",
      password_confirmation: "new_passwor1"
    }
    assert_not_nil flash
    assert_response :unprocessable_entity
  end

  test "should redirect from edit if password link expired" do
    password_reset_token = @confirmed_user.generate_password_reset_token

    travel_to 61.minutes.from_now
    get edit_password_path(password_reset_token)

    assert_redirected_to new_password_path
    assert_not_nil flash[:alert]
  end

  test "should redirect from edit if password link is incorrect" do
    get edit_password_path("not_a_real_token")

    assert_redirected_to new_password_path
    assert_not_nil flash[:alert]
  end

  test "should redirect from edit if user is not confirmed" do
    @confirmed_user.update!(confirmed_at: nil)
    password_reset_token = @confirmed_user.generate_password_reset_token

    get edit_password_path(password_reset_token)

    assert_redirected_to new_confirmation_path
    assert_not_nil flash[:alert]
  end

  test "should redirect from edit if user is authenticated" do
    password_reset_token = @confirmed_user.generate_password_reset_token

    login @confirmed_user

    get edit_password_path(password_reset_token)
    assert_redirected_to root_path
  end

  test "should get new" do
    get new_password_path
    assert_response :ok
  end

  test "should redirect from new if user is authenticated" do
    login @confirmed_user

    get new_password_path
    assert_redirected_to root_path
  end

  test "should send password reset mailer" do
    assert_emails 1 do
      post passwords_path, params: {
        email: @confirmed_user.email.upcase
      }
    end

    assert_redirected_to login_path
    assert_not_nil flash[:notice]
  end

  test "should not send password reset mailer for unconfirmed user" do
    post passwords_path, params: {
      email: @unconfirmed_user.email.upcase
    }

    assert_redirected_to new_confirmation_path
    assert_not_nil flash[:alert]
  end

  test "should not send password reset mailer for unknown user" do
    post passwords_path, params: {
      email: "d'unknown@example.com"
    }

    assert_redirected_to login_path
    assert_not_nil flash[:notice]
  end

  test "should update password" do
    password_reset_token = @confirmed_user.generate_password_reset_token

    put password_path(password_reset_token), params: {
      password: "password",
      password_confirmation: "password"
    }

    assert_redirected_to login_path
    assert_not_nil flash[:notice]
  end

  test "should handle update password request from unconfirmed user" do
    password_reset_token = @unconfirmed_user.generate_password_reset_token

    put password_path(password_reset_token), params: {
      password: "password",
      password_confirmation: "password"
    }

    assert_redirected_to new_confirmation_path
    assert_equal flash[:alert], "You must confirm your email before you can sign in."
  end

  test "should handle update password request with invalid token" do
    password_reset_token = @unconfirmed_user.generate_password_reset_token
    password_reset_token[-1] = " "

    put password_path(password_reset_token), params: {
      password: "password",
      password_confirmation: "password"
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], "Invalid or expired token."
  end

  test "should handle errors" do
    password_reset_token = @confirmed_user.generate_password_reset_token

    put password_path(password_reset_token), params: {
      password: "password",
      password_confirmation: "password_that_does_not_match"
    }

    assert_not_nil flash[:alert]
  end

  test "should not update password if authenticated" do
    password_reset_token = @confirmed_user.generate_password_reset_token

    login @confirmed_user

    put password_path(password_reset_token), params: {
      password: "password",
      password_confirmation: "password"
    }

    get new_password_path
    assert_redirected_to root_path
  end
end
