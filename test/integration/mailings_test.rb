require 'test_helper'

class MailingsControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
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

end  
