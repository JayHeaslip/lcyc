require "test_helper"

class MooringsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "passwor1")
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @membership3 = memberships(:member3)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "show moorings" do
    get moorings_url
    assert_select "h2", "Moorings"
    assert_response :success
  end

  test "show unassigned moorings" do
    get unassigned_moorings_url
    assert_select "h2", "Unassigned Moorings"
    assert_response :success
  end
end
