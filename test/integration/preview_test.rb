require 'test_helper'

class PreviewControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @mailing = mailings(:one)
  end

  test "show" do
    get preview_url(@mailing)
    assert_response :success
  end

end  
