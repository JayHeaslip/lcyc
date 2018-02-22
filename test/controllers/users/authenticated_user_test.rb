require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:three)
    login_as(@user)
    @update = {
      firstname: 'Jim',
      lastname:  'Dave',
      email: 'bob@abc.com',
      password:  'password',
      password_confirmation:  'password'
    }
    
  end
  
  test "should not get index" do
    get users_url
    assert_redirected_to root_url
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
    patch user_url(@user),params: { user: @update}
    assert_redirected_to root_url
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
