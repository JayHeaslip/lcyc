require "test_helper"

class QuickbooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "aqswde12$$")
  end

  test "connect to QB" do
    get connect_quickbooks_path
    assert_response :redirect
  end

  test "get new QB token" do
    get new_quickbook_path, params: { state: "123", error: "456", code: "789" }
    assert_response :redirect
  end

  test "display form to generate invoices" do
    get invoices_quickbooks_path
    assert_response :success
  end
end
