require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "confirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: Time.current, role: roles(:BOG))
    @unconfirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "unconfirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: nil, role: roles(:BOG))

    @member = users(:three)
    @user = users(:two)
    @admin = users(:one)
  end

  test "should generate a summary report" do
    login @confirmed_user
    get summary_report_path
    assert_match /Total: 13/, @response.body
    assert_response :success
  end

  test "should generate a history report" do
    login @confirmed_user
    get history_report_path
    assert_match /<h2>Membership History/, @response.body
    assert_response :success
  end

  test "should generate a moorings report" do
    login @confirmed_user
    get moorings_report_path
    assert_match /<p>Unassigned moorings: 100/, @response.body
    assert_response :success
  end

  test "should generate a moorings report withh a skip mooring error" do
    login @confirmed_user
    get moorings_report_path
    assert_match /<p>Unassigned moorings: 100/, @response.body
    assert_response :success
  end
end
