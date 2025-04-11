require "test_helper"

class WaitListEntriesIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "passwor1")
    @membership = memberships(:member1)
    @wl = wait_list_entries(:wl2)
    @badwl = wait_list_entries(:wl3)
    @wlaccepted = wait_list_entries(:wl1)
  end

  test "get entries" do
    get wait_list_entries_url
    assert_response :success
    assert_select "div p", "Total : 4"
  end

  test "new entry" do
    get new_wait_list_entry_url
    assert_response :success
    assert_select "h2", "New Wait List Entry"
  end

  test "create entry" do
    @membership = memberships(:member2)
    post wait_list_entries_url, params: { wait_list_entry: { membership_id: @membership.id } }
    assert_redirected_to wait_list_entries_url
    assert_equal flash[:notice], "Wait list entry was successfully created."
    @wl = WaitListEntry.last
    assert_equal Date.new(2009, 2, 2), @wl.date
  end

  test "create entry accepted member" do
    @wl = WaitListEntry.new
    @membership = memberships(:member4)
    post wait_list_entries_path, params: { wait_list_entry: { membership_id: @membership.id, notes: "New note" } }
    assert_redirected_to wait_list_entries_path
    assert_equal flash[:notice], "Wait list entry was successfully created."
    @wl = WaitListEntry.last
    assert_equal Date.new(2018, 3, 2), @wl.date
    assert_equal @wl.notes, "New note"
  end

  test "create invalid entry" do
    @wl = WaitListEntry.new
    @membership = memberships(:member4)
    post wait_list_entries_path, params: { force_wld: true, wait_list_entry: { membership_id: @membership.id, notes: "New note" } }
    assert_equal flash[:alert], "Date can't be blank"
    assert_response :unprocessable_entity
  end

  test "edit entry" do
    get edit_wait_list_entry_path(@wl)
    assert_response :success
  end

  test "update entry" do
    patch wait_list_entry_path(@wl), params: { wait_list_entry: { membership_id: @membership.id, notes: "Note" } }
    assert_redirected_to wait_list_entries_path
    assert_equal flash[:notice], "Wait list entry was successfully updated."
  end

  test "update entry forced date" do
    patch wait_list_entry_path(@wl), params: { force_wld: true, wait_list_entry: { membership_id: @membership.id, notes: "Note", date: "02-11-1995" } }
    assert_redirected_to wait_list_entries_path
    assert_equal flash[:notice], "Wait list entry was successfully updated."
    @wl = WaitListEntry.find(ActiveRecord::FixtureSet.identify(:wl2))
    assert_equal @wl.date, Date.new(1995, 11, 2)
  end

  test "update unvalid entry date" do
    patch wait_list_entry_path(@wl), params: { force_wld: true, wait_list_entry: { membership_id: @membership.id, notes: "Note" } }
    assert_response :unprocessable_entity
  end

  test "update entry accepted member" do
    patch wait_list_entry_path(@wlaccepted), params: { wait_list_entry: { membership_id: @wlaccepted.membership_id, notes: "Updated note" } }
    assert_redirected_to wait_list_entries_path
    assert_equal flash[:notice], "Wait list entry was successfully updated."
    @wl = WaitListEntry.find(ActiveRecord::FixtureSet.identify(:wl1))
    assert_equal Date.new(2018, 3, 2), @wl.date
    assert_equal @wl.notes, "Updated note"
  end

  test "delete entry" do
    delete wait_list_entry_url(@wl)
    assert_redirected_to wait_list_entries_url
  end

  test "assign entry" do
    get assign_wait_list_entry_url(@wl)
    assert_response :success
    assert_select "label", "Assigning mooring for: Very Long Mailing Name & another long part"
  end

  test "assign ineligible" do
    get assign_wait_list_entry_url(@badwl)
    assert_equal "Old Joe is not eligible for a mooring.", flash[:alert]
    assert_redirected_to wait_list_entries_path
  end

  test "update mooring" do
    patch mooring_update_wait_list_entry_url(wait_list_entries(:wl4)), params: { mooring: 100 }
    assert_redirected_to wait_list_entries_url
  end

  test "update mooring with boat" do
    @wl2 = wait_list_entries(:wl2)
    patch mooring_update_wait_list_entry_url(@wl2), params: { mooring: 100 }
    assert_redirected_to wait_list_entries_url
  end

  test "update mooring bad membership" do
    @membership = @wl.membership
    @membership.LastName = ""
    @membership.save(validate: false)
    patch mooring_update_wait_list_entry_url(@wl), params: { mooring: 100 }
    assert_response :unprocessable_entity
    assert_select "div p", "Total : 4"
  end
end
