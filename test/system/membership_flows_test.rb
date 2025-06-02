require "application_system_test_case"

class MembershipTest < ApplicationSystemTestCase
  test "new membership" do
    visit root_path
    fill_in "email", with: "dave@abc.com"
    fill_in "password", with: "aqswde12$$"
    click_on "Login"
    click_on "Memberships"
    click_on "New Membership"
    fill_in "MembershipLastName", with: "Doe"
    fill_in "Mailing Name", with: "John Doe"
    fill_in "Street Address", with: "1 Maple St"
    fill_in "City", with: "Burlington"
    fill_in "State", with: "VT"
    fill_in "Zip", with: "05041"
    fill_in "Member Since", with: "2010"
    select "January", from: "membership_active_date_2i"
    select "10", from: "membership_active_date_3i"
    select "2010", from: "membership_active_date_1i"
    select "Active", from: "membership_Status"

    # click_on "Add person"
    within(".person") do
      fill_in "FirstName", with: "John"
      fill_in "LastName", with: "Doe"
      fill_in "BirthYear", with: "1960"
      fill_in "Email", with: "john@abc.com"
      fill_in "CellPhone", with: "802-878-1111"
      select "Boats"
    end

    click_on "Add boat"
    within(".boat") do
      fill_in "Mfg_Size", with: "J/29"
      fill_in "Name", with: "Doe boat"
    end
    click_on "Create Membership"
    assert_text "Membership was successfully created."
    assert_text "Add John Doe to waiting list?"
    click_on "Yes"
    # take_screenshot
    assert_text "Membership"
    assert_text "1 Maple St"
    assert_text "john@abc.com"
    assert_text "802-878-1111"
    assert_text "Doe boat"
  end
end
