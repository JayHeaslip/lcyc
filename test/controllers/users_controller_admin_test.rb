require "test_helper"

class UsersControllerTest1 < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "aqswde12$$")
    @user = users(:two)
    @update = {
      firstname: "Jim",
      lastname: "Bob",
      email: "bob2@abc.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.now,
      role_id: roles(:member).id
    }

    # exists in people but not in users
    @new = {
      firstname: "Jim",
      lastname: "Bob",
      email: "jim2@abc.com",
      password: "password",
      password_confirmation: "password",
      role_id: roles(:BOG).id
    }
    @role = roles(:member)
    @bog = roles(:BOG)
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
    patch user_url(@user), params: { user: @update }
    assert_redirected_to users_url
  end

  test "new user" do
    get sign_up_path
    assert_response :success
  end

  test "create an user" do
    post users_url, params: { user: @new, email_confirmed: true }
    assert_redirected_to users_url
    assert_equal flash[:success], "User was successfully created."
  end

  test "delete an user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end

  test "remove a role from an user" do
    assert_difference("@bog.users.count", -1) do
      delete rmrole_role_user_url(@bog, @user)
    end
    assert_redirected_to role_users_url(@bog)
  end
end
