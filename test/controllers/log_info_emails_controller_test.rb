require "test_helper"

class LogInfoEmailsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @confirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "confirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: Time.current, role: roles(:BOG))
    @membership = memberships(:member6)
    @person = people(:bobsmith)
    @person.EmailAddress = "confirmed_user@example.com"
    @person.save
  end

  test "display an edit form" do
    login @confirmed_user
    get edit_log_info_email_path
    assert_response :success
  end

  test "send log info emails test" do
    login @confirmed_user
    patch log_info_email_path(1), params: { log_info_email: {subject: "[LCYC] Log info verification", body: "Please review the following information. This will be used for your listing in the next LCYC log. If you need to make updates or corrections, please send an email to our Membership chair, Betsey Dempsey, at lcycsecretary@gmail.com.", test: "true" } }
    assert_redirected_to root_url
  end

  test "send log info emails" do
    login @confirmed_user
    patch log_info_email_path(1), params: { log_info_email: {subject: "[LCYC] Log info verification", body: "Please review the following information. This will be used for your listing in the next LCYC log. If you need to make updates or corrections, please send an email to our Membership chair, Betsey Dempsey, at lcycsecretary@gmail.com.", test: "false" } }
    assert_redirected_to root_url
  end

  test "send log info emails test with non member user" do
    login @confirmed_user
    @person.EmailAddress = "nonmember@example.com"
    @person.save
    patch log_info_email_path(1), params: { log_info_email: {subject: "[LCYC] Log info verification", body: "Please review the following information. This will be used for your listing in the next LCYC log. If you need to make updates or corrections, please send an email to our Membership chair, Betsey Dempsey, at lcycsecretary@gmail.com.", test: "true" } }
    assert_redirected_to root_url
  end
end
