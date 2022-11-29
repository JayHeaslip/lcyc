require 'test_helper'

class UsersControllerTest3 < ActionDispatch::IntegrationTest

  def setup
    @user = users(:three)
    @unconfirmed = users(:not_confirmed)
    @user2 = users(:four)
    @update = {
      firstname: 'Jim',
      lastname:  'Bob',
      email: 'bob@abc.com',
      password:  'password',
      password_confirmation:  'password'
    }
    @expired = users(:expired)
  end
  
  test "should not show user" do
    get user_url(@user)
    assert_redirected_to login_url
  end

  test "should not edit user" do
    get edit_user_url(@user)
    assert_redirected_to login_url
  end
    
  test "should not update user" do
    patch user_url(@user),params: { user: @update, role_ids: @role_ids }
    assert_redirected_to login_url
  end
    
  test "should show new user form" do
    get new_user_url
    assert_response :success
  end
    
  test "should create user" do
    @user = User.new
    post users_url, params: {:user => {firstname: 'Tom', lastname: 'tom', email: 'tom@abc.com',
                                       password: 'password', password_confirmation: 'password'}}
    @user = User.find_by_email('tom@abc.com')
    assert_redirected_to registration_info_user_url(@user)
    assert_equal flash[:success], 'User was successfully created.'
  end
  
  test "should not create invalid user" do
    @user = User.new
    post users_url, params: {:user => {firstname: 'Tom', lastname: 'tom', email: 'tom@abc.com',
                                       password: 'password', password_confirmation: 'passwor1'}}
    assert_response :unprocessable_entity
  end
  
  test "should show registration info" do
    get registration_info_user_url(@user)
    assert_response :success
  end

  test "should resend registration email" do
    post resend_email_user_url(@user)
    assert_redirected_to registration_info_user_url(@user)
  end


end
