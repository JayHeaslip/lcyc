require "test_helper"

class AdminIntegrationTest < ActionDispatch::IntegrationTest
  test "login with remember me" do
    post login_url, params: { email: users(:two).email, password: "passwor2", remember_me: "1" }
    assert_redirected_to root_url
  end

  test "login bad password" do
    post login_url, params: { email: users(:two).email, password: "passwor3", remember_me: "1" }
    assert_equal flash[:alert], "Incorrect email or password."

    assert_response :unprocessable_entity
  end
end
