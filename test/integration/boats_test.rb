require 'test_helper'

class BoatsControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @boat = boats(:boat1)
  end

  test "get_index" do
    get boats_url
    assert_response :success
  end

end  
