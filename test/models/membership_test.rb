require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  setup do
    @boat = boats(:boat10)
    @membership = memberships(:member10)
    @mooring = mooring(:mooring10)
  end

  test "should return blank message if location is blank or nil" do
    @boat.location = ""
    assert_equal "", @membership.update_drysail_and_mooring(@boat)
  end

  test "should assign boat to mooring" do
    @boat.mooring = nil
    @boat.location = "Mooring"
    assert_equal "", @membership.update_drysail_and_mooring(@boat)
    assert_equal @boat.mooring, @membership.mooring
  end

  test "should assign boat to drysail" do
    @boat.drysail = nil
    @boat.location = "Parking Lot"
    assert_equal "", @membership.update_drysail_and_mooring(@boat)
    assert_equal @boat.drysail, @membership.drysail
  end

  test "should not assign boat to mooring if boat mooring is not nil" do
    @boat.location = "Mooring"
    @boat.mooring = mooring(:mooring10)
    old_mooring = @boat.mooring
    assert_equal "", @membership.update_drysail_and_mooring(@boat)
    assert_equal old_mooring, @boat.mooring
  end

  test "should not assign boat to mooring if mooring is not available" do
    @boat.location = "Mooring"
    @mooring.memberships = []
    @boat.mooring = nil
    assert_equal "Mooring not available for boat.\n", @membership.update_drysail_and_mooring(@boat)
    assert_equal @boat.location, ""
  end

  test "should not assign boat to drysail if drysail is not nil" do
    @boat.location = "Parking Lot"
    @boat.drysail = drysails(:drysail10)
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
