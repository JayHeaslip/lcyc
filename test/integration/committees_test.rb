require "test_helper"

class CommitteesIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "aqswde12$$")
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "download_spreadsheet" do
    get download_committee_url(committees(:boats))
    assert_response :success
  end

  test "download_all_spreadsheet" do
    get download_all_committees_url
    assert_response :success
  end

  test "get_committee" do
    get select_committees_url
    assert_response :success
    assert_select "h2", "Committee Members"
  end

  test "show_committee" do
    get list_committees_url, params: { committee: "Boats" }
    assert_response :success
    assert_select "h2", "Boats Committee"
  end

  test "show_all_committees" do
    get list_committees_url, params: { committee: "All" }
    assert_response :success
    assert_select "h2", "Committee listing for all members"
  end
end
