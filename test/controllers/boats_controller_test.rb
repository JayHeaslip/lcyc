require "test_helper"

class BoatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "confirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: Time.current, role: roles(:Harbormaster))
    @unconfirmed_user = User.create!(firstname: "bob", lastname: "bob", email: "unconfirmed_user@example.com", password: "password", password_confirmation: "password", confirmed_at: nil, role: roles(:BOG))

    @member = users(:three)
    @user = users(:two)
    @admin = users(:one)
    @boat = boats(:boat1)
  end

  test "should list boats" do
    login @confirmed_user
    get boats_url
    assert_response :ok
  end

  test "should show a boat" do
    login @confirmed_user
    get boat_url(@boat)
    assert_response :ok
  end

  test "should edit a boat" do
    login @confirmed_user
    get edit_boat_url(@boat)
    assert_response :ok
  end

end
