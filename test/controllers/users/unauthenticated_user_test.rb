require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should not show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should not edit user" do
    get edit_user_url(@user)
    assert_response :success
  end
    
  test "should not update user" do
  end
    
  test "shoudl not edit password" do
  end
    
  test "should not update password" do
  end
    
  test "should show new user form" do
  end
    
  test "should create user" do
  end
  
  test "should show registration info" do
  end

  test "should resend registration email" do
  end

  test "should confirm email" do
  end

  test "should send forgot password email" do
  end

  test "should reset password with correct hash" do
  end

  test "should not reset password with incorrect hash" do
  end

end
