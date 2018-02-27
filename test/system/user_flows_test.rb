require 'application_system_test_case'

class UserTest < ApplicationSystemTestCase

  test "register" do
    visit root_path
    click_on "Create an account"
    take_screenshot
    fill_in "firstname", with: "john"
    fill_in "lastname", with: "john"
    fill_in "email", with: "john@abc.com"
    fill_in "password", with: "password"
    fill_in "password_confirmation", with: "password"
    click_on "Register"
    assert_text "User was successfully created."
  end
end
