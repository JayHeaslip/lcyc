require 'test_helper'

class UsersControllerTest2 < ActionDispatch::IntegrationTest

  setup do
    @user = users(:two)
    login_as(@user,'passwor2')
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
    assert_redirected_to user_path(@user)
  end
    
  test "update invalid user" do
    @update[:password_confirmation] = 'passwor1'
    patch user_url(@user),params: { user: @update}
    assert_response :unprocessable_entity
  end
    
  test "edit current password" do
    get change_password_url(@user)
    assert_response :success
  end
    
  test "update current password" do
    post change_password_url(@user), params: { current_password: 'passwor2',
                                            password: 'password',
                                            password_confirmation: 'password' }
    assert_redirected_to root_url
  end
    
  test "update current password incorrect old password" do
    post change_password_url(@user), params: { current_password: 'passwor3',
                                            password: 'password',
                                            password_confirmation: 'password' }
    assert_response :unprocessable_entity
    assert_equal "Incorrect current password", flash.now[:alert]
  end

  test "update current password invalid new password" do
    post change_password_url(@user), params: { old_password: 'passwor2',
                                            password: 'password',
                                            password_confirmation: 'passwor1' }
    assert_response :unprocessable_entity
    assert_equal "Incorrect current password", flash.now[:alert]
  end
    
  test "should not delete an user" do
  end
    
  test "should not remove a role from an user" do
  end

end
