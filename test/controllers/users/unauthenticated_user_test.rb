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
    
  test "should not edit password" do
    get editpw_user_url(@user)
    assert_redirected_to login_url
  end
    
  test "should not update password" do
    post updatepw_user_url(@user),params: { old_password: @user.password,
                                            password: 'passwd1',
                                            password_confirmation: 'passwd1'}
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
    assert_response :success
  end
  
  test "should show registration info" do
    get registration_info_user_url(@user)
    assert_response :success
  end

  test "should resend registration email" do
    post resend_email_user_url(@user)
    assert_redirected_to registration_info_user_url(@user)
  end

  test "should confirm email, correct hash" do
    get confirm_email_url(@user.confirmation_hash)
    assert @user.email_confirmed = true
    assert_redirected_to login_url
  end

  test "should confirm email, incorrect hash" do
    get confirm_email_url(@user.hash)
    assert @user.email_confirmed = true
    assert_redirected_to login_url
  end

  test "should display forgot password form" do
    get forgotpw_users_url
    assert_response :success
  end

  test "should redirect from password form if not confirmed" do
    post forgotpw_users_url, params: {user: {email: 'unconfirmed@abc.com'}}
    assert_redirected_to registration_info_user_url(@unconfirmed)
    assert_equal flash[:success], 'Please confirm your account before trying to reset your password.'
  end

  test "should send forgot password email" do
    post forgotpw_users_url, params: {user: {email: 'steve@abc.com'}}
    assert_redirected_to login_url
  end

  test "should go back to form if email is not found" do
    post forgotpw_users_url, params: {user: {email: 'none@abc.com'}}
    assert_response :success
  end

  test "should show reset password form with correct hash" do
    get rp_url(@user2.reset_password_code)
    assert_response :success
  end

  test "should reset password with correct hash" do
    patch rp_url(@user2.reset_password_code), params: {user: {password: 'password',
                                                            password_confirmation: 'password'}}
    assert_redirected_to login_url
  end

  test "should not reset password with incorrect parms" do
    patch rp_url(@user2.reset_password_code), params: {user: {password: 'password',
                                                            password_confirmation: 'passwor1'}}
    assert_response :success
  end

  test "should not reset password with expired hash" do
    get rp_url(@expired.reset_password_code)
    assert_redirected_to forgotpw_users_url
  end

end
