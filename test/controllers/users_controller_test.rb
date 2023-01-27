require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "confirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: Time.current, role: roles(:BOG))
    @unconfirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "unconfirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: nil, role: roles(:BOG))

    @member = users(:three)
    @user = users(:two)
    @admin = users(:one)
  end

  test "should load sign up page for anonymous users" do
    get sign_up_path
    assert_response :ok
  end

  test "should redirect authenticated users from signing up" do
    login @confirmed_user

    get sign_up_path
    assert_redirected_to root_path

    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: {
          email: "some_unique_email@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
  end

  test "should not show unconfirmed user" do
    get user_url(@unconfirmed_user)
    assert_redirected_to login_url
  end

  test "should not edit unconfirmed user" do
    get edit_user_url(@unconfirmed_user)
    assert_redirected_to login_url
  end

  test "should not update unconfirmed user" do
    patch user_url(@unconfirmed_user), params: {user: @update, role_ids: @role_ids}
    assert_redirected_to login_url
  end

  test "should create user and send confirmation instructions" do
    assert_difference("User.count", 1) do
      assert_emails 1 do
        post sign_up_path, params: {
          user: {
            firstname: "bob",
            lastname: "bob",
            email: "some_unique_email@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end
    end

    assert_redirected_to login_path
    assert_not_nil flash[:notice]
  end

  test "should handle errors when signing up" do
    assert_no_difference("User.count") do
      assert_no_emails do
        post sign_up_path, params: {
          user: {
            firstname: "bob",
            lastname: "bob",
            email: "some_unique_email@example.com",
            password: "password",
            password_confirmation: "wrong_password"
          }
        }
      end
    end
    assert_response :unprocessable_entity
  end

  test "should not get index" do
    login_as @member, "passwor3"
    get users_url, headers: {HTTP_REFERER: root_url}
    assert_redirected_to root_url
    assert_not_nil flash[:alert]
  end

  test "should list current user" do
    login_as @member, "passwor3"
    get user_path(@member)
    assert_response :success
  end

  test "should get edit if authorized" do
    login_as @member, "passwor3"

    get edit_user_path(@member)
    assert_response :ok
  end

  test "should redirect unauthorized user from editing account" do
    get edit_user_path(@unconfirmed_user)
    assert_redirected_to login_path
    assert_not_nil flash[:alert]
  end

  test "should edit user" do
    current_first = @member.firstname

    login_as @member, "passwor3"

    put account_path, params: {
      user: {
        firstname: "Tom"
      }
    }

    assert_not_nil flash[:notice]
    assert_not_equal current_first, @member.reload.firstname
  end

  test "update invalid user" do
    login_as @member, "passwor3"
    patch user_url(@member), params: {user: {firstname: "", lastname: @member.lastname}}
    assert_response :unprocessable_entity
  end

  test "should not delete an user" do
    login_as @member, "passwor3"
    delete user_path(@user), headers: {HTTP_REFERER: root_url}
    assert_redirected_to root_path
    assert_not_nil flash[:alert]
  end

  test "should not remove a role from an user" do
  end
end
