require "test_helper"

class ActiveSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Role.find_by_name("Admin")
    @confirmed_user = User.create!(firstname: "Jim", lastname: "Bob", email: "confirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: Time.current, role: @admin)
  end

  test "should destroy another session" do
    login @confirmed_user
    @confirmed_user.active_sessions.create!

    assert_difference("ActiveSession.count", -1) do
      delete active_session_path(@confirmed_user.active_sessions.last)
    end

    assert_redirected_to edit_user_path(@confirmed_user)
    assert_not_nil current_user
    assert_not_nil flash[:notice]
  end

  test "should destroy current session" do
    login @confirmed_user, remember_user: true


    assert_difference("ActiveSession.count", -1) do
      delete active_session_path(@confirmed_user.active_sessions.last)
    end

    assert_redirected_to edit_user_path(@confirmed_user)
    assert_nil current_user
    assert_not_nil flash[:notice]
  end

  test "should destroy current session and forget current active session" do
    login @confirmed_user, remember_user: true

    assert_difference("ActiveSession.count", -1) do
      delete active_session_path(@confirmed_user.active_sessions.last)
    end

    assert_nil current_user
  end

  test "should list all active sessions" do
    login @confirmed_user
    get active_sessions_path
    assert_response :success
  end
end
