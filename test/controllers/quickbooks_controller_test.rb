require "test_helper"

class QuickbooksControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, "passwor1")
  end

  test "cleanup the database" do
    get cleanup_quickbooks_path
    assert_response :success
  end

  test "connect to QB" do
    get connect_quickbooks_path
    assert_response :redirect
  end

  test "get new QB token" do
    get new_quickbook_path, params: { state: "123", error: "456", code: "789" }
    assert_response :success
  end

  test "get new QB token, matching session" do
    session[:state] = "123"
    get new_quickbook_path, params: { state: "123", error: "456", code: "789" }
    assert_response :success
  end
end
