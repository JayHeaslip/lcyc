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
    @boat = boats(:boat3)
    @membership = memberships(:member5)
    @boat.mooring = nil
    @boat.location = "Mooring"
    assert_equal "", @membership.update_drysail_and_mooring(@boat)
    assert_equal @boat.mooring, @membership.mooring
  end

  test "should assign boat to drysail" do
    @boat = boats(:boat3)
    @membership = memberships(:member5)
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

  test "should not assign boat to drysail if drysail is not available" do
    @boat.location = "Parking Lot"
    @mooring.memberships = []
    @boat.drysail = nil
    assert_equal "Drysail spot not available for boat.\n", @membership.update_drysail_and_mooring(@boat)
    assert_equal @boat.location, ""
  end

  test "should not assign boat to drysail if drysail is not nil" do
    @boat.location = "Parking Lot"
    @boat.drysail = drysails(:drysail10)
    assert_nil @boat.update_drysail_and_mooring
  end

  test "should generate a partner cc email" do
    assert_equal @membership.cc_email, "sue@abc.com"
  end

  test "should generate a partner cc email, blank partner email" do
    @partner = people(:p10)
    @partner.EmailAddress = ""
    @partner.save
    assert_equal @membership.cc_email, ""
  end

  test "should generate a partner cc email, blank member email" do
    @member = people(:mem10)
    @member.EmailAddress = ""
    @member.save
    assert_equal @membership.cc_email, ""
  end

  test "should generate a partner cc email, prefer partner" do
    @membership.prefer_partner_email = true
    @membership.save
    assert_equal @membership.cc_email, "joe@abc.com"
  end
end
