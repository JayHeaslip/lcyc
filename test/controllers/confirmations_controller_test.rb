require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_user = User.create!(firstname: "Jim", lastname: "Bob", email: "confirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: 1.week.ago, role: roles(:member))
    @unconfirmed_user = User.create!(firstname: "Jim", lastname: "Bob", email: "unconfirmed_user@example.com",
      password: "password", password_confirmation: "password", role: roles(:member))
  end

  test "should confirm unconfirmed user" do
    freeze_time do
      confirmation_token = @unconfirmed_user.generate_confirmation_token

      get edit_confirmation_path(confirmation_token)

      assert @unconfirmed_user.reload.confirmed?
      assert_equal Time.now, @unconfirmed_user.confirmed_at
      assert_redirected_to login_path
      assert_not_nil flash[:notice]
    end
  end

  test "should redirect if confirmation link expired" do
    confirmation_token = @unconfirmed_user.generate_confirmation_token

    travel_to 61.minutes.from_now do
      get edit_confirmation_path(confirmation_token)

      assert_nil @unconfirmed_user.reload.confirmed_at
      assert_not @unconfirmed_user.reload.confirmed?
      assert_redirected_to new_confirmation_path
      assert_not_nil flash[:alert]
    end
  end

  test "should redirect if confirmation link is incorrect" do
    get edit_confirmation_path("not_a_real_token")
    assert_redirected_to new_confirmation_path
    assert_not_nil flash[:alert]
  end

  test "should resend confirmation email if user is unconfirmed" do
    assert_emails 1 do
      post confirmations_path, params: { user: { email: @unconfirmed_user.email } }
    end

    assert_redirected_to login_path
    assert_not_nil flash[:notice]
  end

  test "should prevent user from confirming if they are already confirmed" do
    assert_no_emails do
      post confirmations_path, params: { user: { email: @confirmed_user.email } }
    end
    assert_redirected_to new_confirmation_path
    assert_not_nil flash[:alert]
  end

  test "should get new if not authenticated" do
    get new_confirmation_path
    assert_response :ok
  end

  test "should prevent authenticated user from confirming" do
    freeze_time do
      confirmation_token = @confirmed_user.generate_confirmation_token

      login @confirmed_user

      get edit_confirmation_path(confirmation_token)

      assert_not_equal Time.current, @confirmed_user.reload.confirmed_at
      assert_redirected_to new_confirmation_path
      assert_not_nil flash[:alert]
    end
  end

  test "should prevent authenticated user from submitting the confirmation form" do
    login @confirmed_user

    get new_confirmation_path
    assert_redirected_to root_path
    assert_not_nil flash[:alert]

    assert_no_emails do
      post confirmations_path, params: { user: { email: @confirmed_user.email } }
    end

    assert_redirected_to root_path
    assert_not_nil flash[:alert]
  end
end
