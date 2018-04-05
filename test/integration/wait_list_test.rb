require 'test_helper'

class WaitListEntriesControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @wl = wait_list_entries(:wl1)
  end

  test "get entries" do
    get wait_list_entries_url
    assert_response :success
    assert_select "div p", "Total : 2"
  end

  test "new entry" do
    get new_wait_list_entry_url
    assert_response :success
    assert_select "h2", "New Wait List Entry"
  end

  test "create entry" do
    post wait_list_entries_url, params: {wait_list_entry: {membership_id: @membership.id}}
    assert_redirected_to  wait_list_entries_url
  end

  test "invalid entry" do
    post wait_list_entries_url, params: {wait_list_entry: {membership_id: 0}}
    assert_select "h2", "New Wait List Entry"
  end

  test "delete entry" do
    delete wait_list_entry_url(@wl)
    assert_redirected_to  wait_list_entries_url
  end

  test "assign entry" do
    get assign_wait_list_entry_url(@wl)
    assert_response :success
    assert_select "label", "Assigning mooring for: Tom"
  end

  test "update mooring" do
    patch mooring_update_wait_list_entry_url(@wl), params: {mooring: 100}
    assert_redirected_to wait_list_entries_url
  end

  test "update bad mooring" do
    patch mooring_update_wait_list_entry_url(@wl), params: {mooring: 200}
    assert_response :success
    assert_select "div p", "Total : 2"
  end

end  
