require 'test_helper'

class UsersControllerTest1 < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @user = users(:two)
    @update = {
      firstname: 'Jim',
      lastname:  'Bob',
      email: 'bob@abc.com',
      password:  'password',
      password_confirmation:  'password'
    }
    @role_ids = [roles(:BOG).id, roles(:member).id]
    @BOG = roles(:BOG)
  end
  
  test "get index" do
    get users_url
    assert_response :success
  end
    
  test "get index with roles" do
    get role_users_url(roles(:BOG))
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
    patch user_url(@user),params: { user: @update, role_ids: @role_ids }
    assert_redirected_to users_url
  end
    
  test "delete an user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end
    
  test "remove a role from an user" do
    assert_difference('@BOG.users.count', -1) do
      delete rmrole_role_user_url(@BOG,@user)
    end
    assert_redirected_to roles_url
  end

end
