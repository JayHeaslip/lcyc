require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    login_as(users(:one))
    @user = users(:two)
  end
  
  test "get index" do
    get users_url
    assert_response :success
  end
    
  test "list any user" do
    get user_url(@user)
    assert_response :success
  end

  test "edit an user" do
    get edit_user_url(@user)
    assert_response :success
  end
    
  test "update an user" do
    patch user_url(@user)
    assert_response :success
  end
    
  test "delete an user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end
    
  test "remove a role from an user" do
  end

end
