require "test_helper"

class BoatTest < ActiveSupport::TestCase
  setup do
    @boat = boats(:boat10)
    @membership = memberships(:member10)
    @mooring = mooring(:mooring10)
  end

  test "should return nil message if location is blank or nil" do
    @boat.location = ""
    assert_nil @boat.update_drysail_and_mooring
  end

  test "should assign boat to mooring" do
    @boat = boats(:boat11)
    @membership = memberships(:member11)
    @boat.location = "Mooring"
    assert_nil @boat.update_drysail_and_mooring
    assert_equal @boat.mooring, @membership.mooring
  end

  test "should assign boat to drysail" do
    @boat = boats(:boat3)
    @membership = memberships(:member5)
    @boat.drysail = nil
    @boat.location = "Parking Lot"
    assert_nil @boat.update_drysail_and_mooring
    assert_equal @boat.drysail, @membership.drysail
  end

  test "should not assign boat to mooring if mooring is not nil" do
    @boat = boats(:boat1)
    @membership = memberships(:member3)
    @boat.location = "Mooring"
    assert_nil @boat.update_drysail_and_mooring
  end

  test "should not assign boat to mooring if mooring is not available" do
    @boat.location = "Mooring"
    @mooring.memberships = []
    @boat.mooring = nil
    assert_equal "Mooring not available for boat.\n", @boat.update_drysail_and_mooring
    assert_equal @boat.location, ""
  end

  test "should not assign boat to drysail if drysail is not nil" do
    @boat = boats(:boat1)
    @membership = memberships(:member5)
    @boat.location = "Parking Lot"
    assert_nil @boat.update_drysail_and_mooring
  end

  test "should not assign boat to drysail if drysail is not available" do
    @boat.location = "Parking Lot"
    @boat.drysail = nil
    @membership.drysail = nil
    assert_equal "Drysail spot not available for boat.\n", @boat.update_drysail_and_mooring
    assert_equal @boat.location, ""
  end
end
