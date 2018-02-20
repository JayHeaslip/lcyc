require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    login_as(users(:two))
  end
  
  test "should not get index" do
    get users_url
    assert_response :success
  end
    
  test "should not list any user" do
    get user_url(@user)
    assert_response :success
  end

  test "should list current user" do
    get user_url(@user)
    assert_response :success
  end

  test "edit current user" do
    get edit_user_url(@user)
    assert_response :success
  end
    
  test "update current user" do
  end
    
  test "edit current password" do
  end
    
  test "update current password" do
  end
    
  test "should not delete an user" do
  end
    
  test "should not remove a role from an user" do
  end

end
