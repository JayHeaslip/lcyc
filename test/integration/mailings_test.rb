require 'test_helper'

class MailingsControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
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
    post mailings_url, params: {mailing: {subject: 'test2' , body: 'test'}}
    @mailing = Mailing.find_by_subject('test2')
    assert_redirected_to mailing_url(@mailing)
  end

  test "create with committee" do
    post mailings_url, params: {mailing: {subject: 'test2' , body: 'test', committee: 'Boats'}}
    @mailing = Mailing.find_by_subject('test2')
    assert_redirected_to mailing_url(@mailing)
  end

  test "create bad" do
    post mailings_url, params: {mailing: {body: 'test'}}
    assert_response :success
  end

  test "edit" do
    get edit_mailing_url(@mailing)
    assert_response :success
  end

  test "update" do
    patch mailing_url(@mailing), params: {mailing: {subject: 'test3' , body: 'test'}}
    @mailing = Mailing.find_by_subject('test3')
    assert_redirected_to mailing_url(@mailing)
  end

  test "update bad" do
    patch mailing_url(@mailing), params: {mailing: {subject: ' ', body: 'test22'}}
    assert_response :success
  end

  test "delete" do
    delete mailing_url(@mailing)
    assert_redirected_to mailings_url
  end

  test "billings" do
    get billing_mailings_url
    assert_response :success
  end

  test "send bills" do
    post send_bills_mailings_url
    assert_redirected_to root_path
  end

  test "send bills test" do
    post send_bills_mailings_url, params: {test: true}
    assert_redirected_to root_path
  end

  test "send bills no member email" do
    login_as(users(:barb2), 'passwor2')
    post send_bills_mailings_url, params: {test: true}
    assert_redirected_to root_path
  end

  test "send bills no email" do
    post send_bills_mailings_url
    assert_equal 'Note: bill was not sent for Joe No email, no valid email<br/>',flash[:notice]
    assert_redirected_to root_path
  end

  test "send mailing" do
    post send_email_mailing_url(@mailing)
    assert_redirected_to mailings_url
  end

  test "send mailing with committee" do
    @mailing.committee = 'Boats'
    @mailing.save
    post send_email_mailing_url(@mailing)
    assert_redirected_to mailings_url
  end

  test "send test mailing" do
    post send_email_mailing_url(@mailing), params: {test: true}
    assert_redirected_to mailings_url
  end

  test "send test mailing no email" do
    login_as(users(:no_member_email), 'passwor2')
    post send_email_mailing_url(@mailing), params: {test: true}
    assert_equal "Current user's email not found in membership database", flash[:error]
    assert_redirected_to mailings_url
  end

end  
