require "test_helper"

class MailingsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "passwor1")
    @mailing = mailings(:one)
  end

  test "index" do
    get mailings_url
    assert_response :success
  end

  test "show" do
    get mailing_url(@mailing)
    assert_response :success
  end

  test "new" do
    get new_mailing_url
    assert_response :success
  end

  test "create" do
    post mailings_url, params: {mailing: {subject: "test2", body: "test"}}
    @mailing = Mailing.find_by_subject("test2")
    assert_redirected_to mailing_url(@mailing)
  end

  test "create with committee" do
    post mailings_url, params: {mailing: {subject: "test2", body: "test", committee: "Boats"}}
    @mailing = Mailing.find_by_subject("test2")
    assert_redirected_to mailing_url(@mailing)
  end

  test "create bad" do
    post mailings_url, params: {mailing: {body: "test"}}
    assert_response :unprocessable_entity
  end

  test "edit" do
    get edit_mailing_url(@mailing)
    assert_response :success
  end

  test "update" do
    patch mailing_url(@mailing), params: {mailing: {subject: "test3", body: "test"}}
    @mailing = Mailing.find_by_subject("test3")
    assert_redirected_to mailing_url(@mailing)
  end

  test "update bad" do
    patch mailing_url(@mailing), params: {mailing: {subject: " ", body: "test22"}}
    assert_response :unprocessable_entity
  end

  test "delete" do
    delete mailing_url(@mailing)
    assert_redirected_to mailings_url
  end

  test "send mailing" do
    post send_email_mailing_url(@mailing)
    assert_redirected_to mailings_url
  end

  test "send mailing with committee" do
    @mailing.committee = "Boats"
    @mailing.save
    post send_email_mailing_url(@mailing)
    assert_redirected_to mailings_url
  end

  test "send test mailing" do
    post send_email_mailing_url(@mailing), params: {test: true}
    assert_redirected_to mailings_url
  end

  test "send too soon" do
    t = Time.now
    old_email = mailings(:two)
    old_email.sent_at = t
    old_email.save
    post send_email_mailing_url(@mailing)
    formatted_time = (t + 8.hours).strftime("%m/%d/%Y at %I:%M %p")
    assert_equal "You've sent a mailing within the last 8 hours, please wait until #{formatted_time} to send an email", flash[:error]
  end

  test "send test mailing non-member email" do
    logout
    login_as(users(:no_member_email), "passwor2")
    post send_email_mailing_url(@mailing), params: {test: true}
    assert_equal "Delivering mail.", flash[:notice]
    assert_redirected_to mailings_url
  end
end
