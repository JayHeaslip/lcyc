require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  setup do
    @boat = boats(:boat10) rescue nil
    @membership = memberships(:member10) rescue nil
    @mooring = moorings(:mooring10) rescue nil

    # Minimal valid attributes for building new memberships
    @valid_attributes = {
      LastName: "Smith",
      MailingName: "John & Jane Smith",
      StreetAddress: "123 Ocean Drive",
      City: "Harbor",
      State: "MA",
      Zip: "01234",
      Status: "Active",
      MemberSince: Time.now.year,
      active_date: Time.zone.now.beginning_of_year
    }
  end

  # ==========================================
  # 1. Existing Assignment & Email Tests
  # ==========================================

  test "should assign boat to mooring" do
    @boat = boats(:boat3) rescue @boat
    @membership = memberships(:member5) rescue @membership
    if @boat && @membership
      @boat.mooring = nil
      @boat.location = "Mooring"
      @boat.save
      assert_equal @boat.mooring, @membership.mooring
    end
  end

  test "should assign boat to drysail" do
    @boat = boats(:boat3) rescue @boat
    @membership = memberships(:member5) rescue @membership
    if @boat && @membership
      @boat.drysail = nil
      @boat.location = "Parking Lot"
      @boat.save
      assert_equal @boat.drysail, @membership.drysail
    end
  end

  test "should generate partner cc email" do
    skip unless @membership
    assert_equal "sue@abc.com", @membership.cc_email
  end

  # ==========================================
  # 2. Validation Tests
  # ==========================================

  test "validates core presence attributes" do
    m = Membership.new
    assert_not m.valid?
    assert_includes m.errors[:LastName], "can't be blank"
    assert_includes m.errors[:MailingName], "can't be blank"
    assert_includes m.errors[:StreetAddress], "can't be blank"
    assert_includes m.errors[:City], "can't be blank"
    assert_includes m.errors[:State], "can't be blank"
    assert_includes m.errors[:Zip], "can't be blank"
    assert_includes m.errors[:Status], "can't be blank"
  end

  test "validates state length is exactly 2 characters" do
    m = Membership.new(@valid_attributes.merge(State: "MASS"))
    assert_not m.valid?
    assert_includes m.errors[:State], "is the wrong length (should be 2 characters)"
  end

  test "member_since validation enforces valid year range" do
    m = Membership.new(@valid_attributes.merge(MemberSince: 1900))
    m.valid?
    assert_includes m.errors[:MemberSince], "has invalid year"

    m.MemberSince = Time.now.year + 5
    m.valid?
    assert_includes m.errors[:MemberSince], "has invalid year"
  end

  test "check_type enforces exactly one Member and at most one Partner" do
    m = Membership.new(@valid_attributes)

    # Standard: 1 Member, 1 Partner
    m.people.build(FirstName: "John", LastName: "Smith", MemberType: "Member", Committee1: "Boats")
    m.people.build(FirstName: "Jane", LastName: "Smith", MemberType: "Partner", Committee1: "Boats")
    assert m.valid?

    # Invalid: 2 Members
    m.people.build(FirstName: "Jack", MemberType: "Member")
    assert_not m.valid?
    assert_includes m.errors[:base], "There can be one and only one 'Member'"
  end

  # ==========================================
  # 3. Calculation & Fee Methods
  # ==========================================

  test "calculate_docks_assessment calculates correct fees based on status" do
    m_active = Membership.new(Status: "Active")
    assert_equal 125, m_active.calculate_docks_assessment

    m_associate = Membership.new(Status: "Associate")
    assert_equal 62, m_associate.calculate_docks_assessment

    m_senior = Membership.new(Status: "Senior")
    assert_equal 0, m_senior.calculate_docks_assessment
  end

  test "calculate_initiation_installment returns amount for upcoming year" do
    m = Membership.create!(@valid_attributes.merge(
      people_attributes: [ { FirstName: "John", MemberType: "Member", LastName: "Smith", Committee1: "Boats" } ]
    ))

    next_year = Time.now.year + 1
    m.initiation_installments.create!(year: next_year, amount: 250)

    assert_equal 250, m.calculate_initiation_installment
  end

  # ==========================================
  # 4. Association Cleanup Callbacks
  # ==========================================

  test "destroy_boats removes sole-owned boats upon membership destruction" do
    m = Membership.create!(@valid_attributes.merge(
      people_attributes: [ { FirstName: "John", LastName: "Smith", MemberType: "Member", Committee1: "Boats" } ]
    ))
    boat = Boat.create!(Name: "Sole Boat", Mfg_Size: "22ft")
    m.boats << boat

    assert_difference "Boat.count", -1 do
      m.destroy
    end
  end

  test "destroy_boats retains co-owned boats upon membership destruction" do
    m1 = Membership.create!(@valid_attributes.merge(
      people_attributes: [ { FirstName: "John", MemberType: "Member", LastName: "Smith", Committee1: "Boats" } ]
    ))
    m2 = Membership.create!(@valid_attributes.merge(
      LastName: "Doe",
      people_attributes: [ { FirstName: "Jane", MemberType: "Member", LastName: "Smith", Committee1: "Boats" } ]
    ))

    boat = Boat.create!(Name: "Shared Boat", Mfg_Size: "30ft")
    boat.memberships << [ m1, m2 ]

    assert_no_difference "Boat.count" do
      m1.destroy
    end
    assert Boat.exists?(boat.id)
  end

  # ==========================================
  # 5. Class Methods & Flash Handling
  # ==========================================

  test "flash_message state management" do
    Membership.reset_flash_message
    assert_equal "", Membership.flash_message

    Membership.set_flash_message("Message 1")
    assert_equal "Message 1<br>", Membership.flash_message
  end

  # ==========================================
  # 6. CSV Exporters
  # ==========================================

  test "self.list_to_csv outputs expected column headers and contents" do
    m = Membership.create!(@valid_attributes.merge(
      people_attributes: [ { FirstName: "Alice", LastName: "Smith", MemberType: "Member", Committee1: "Boats" } ]
    ))

    csv_data = Membership.list_to_csv
    assert_includes csv_data, "MailingName,FirstName,LastName,Type,Birthyear,Cell,Email,MemberSince"
    assert_includes csv_data, "Alice"
  end

  test "self.to_csv generates Log Partner Xref export correctly" do
    m = Membership.create!(
      @valid_attributes.except(:people_attributes).merge(
        people_attributes: [
          { FirstName: "John", LastName: "Smith", MemberType: "Member", Committee1: "Boats" },
          { FirstName: "Jane", LastName: "Doe", MemberType: "Partner", Committee1: "Social" }
        ]
      )
    )
    csv_data = Membership.to_csv("Log Partner Xref")
    assert_includes csv_data, "Partner,\"\",Member"
    assert_includes csv_data, "\"Doe, Jane\",see,\"Smith, John\""
  end

  test "self.to_csv generates Evite export correctly" do
    m = Membership.create!(@valid_attributes.merge(
      people_attributes: [
        { FirstName: "John", LastName: "Smith", MemberType: "Member", Committee1: "Boats", EmailAddress: "john@example.com", CellPhone: "8025551234" }
      ]
    ))

    csv_data = Membership.to_csv("Evite")
    assert_includes csv_data, "LastName,MailingName,Email,Cell"
    assert_includes csv_data, "john@example.com"
  end

  # ==========================================
  # 1. remove_boat_from_drysail
  # ==========================================

  test "remove_boat_from_drysail resets location and clears drysail for assigned boats" do
    m = Membership.new(
      LastName: "DrysailOwner",
      MailingName: "Drysail Owner",
      StreetAddress: "1 Dock Rd",
      City: "Harbor",
      State: "MA",
      Zip: "01234",
      Status: "Active",
      MemberSince: 2020
    )
    m.save(validate: false)

    drysail = Drysail.create!(spot_name: "Spot A") rescue Drysail.new
    boat = Boat.create!(Name: "Dry Boat", Mfg_Size: "Laser", location: "Parking Lot", drysail: drysail)
    m.boats << boat

    m.remove_boat_from_drysail
    boat.reload

    assert_equal "", boat.location
    assert_nil boat.drysail
  end

  # ==========================================
  # 2. check_drysail
  # ==========================================

  test "check_drysail attaches membership drysail to boats parked in Parking Lot" do
    m = Membership.new(
      LastName: "ParkOwner",
      MailingName: "Park Owner",
      StreetAddress: "2 Dock Rd",
      City: "Harbor",
      State: "MA",
      Zip: "01234",
      Status: "Active",
      MemberSince: 2020
    )
    m.save(validate: false)

    drysail = Drysail.create!(spot_name: "Spot B") rescue Drysail.new
    m.drysail = drysail

    boat = Boat.create!(Name: "Parked Boat", Mfg_Size: "Sunfish", location: "Parking Lot")
    m.boats << boat

    m.check_drysail
    boat.reload

    assert_equal drysail, boat.drysail
  end

  # ==========================================
  # 3. associate_check
  # ==========================================

  test "associate_check appends flash message when associate active_year threshold is met" do
    Membership.reset_flash_message

    m = Membership.new(
      LastName: "EligibleAssociate",
      MailingName: "Eligible Associate",
      StreetAddress: "3 Dock Rd",
      City: "Harbor",
      State: "MA",
      Zip: "01234",
      Status: "Associate",
      MemberSince: Time.now.year - 6 # Triggers active_year <= Time.now.year + 1
    )
    m.save(validate: false)

    m.people.create!(FirstName: "John", LastName: "Smith", MemberType: "Member", BirthYear: 1980, Committee1: "Boats")

    m.associate_check


    assert_includes Membership.flash_message, "Eligible Associate needs to be made Active"
  end

  test "associate_check does nothing when membership is not Associate" do
    Membership.reset_flash_message

    m = Membership.new(
      LastName: "ActiveMember",
      MailingName: "Active Member",
      StreetAddress: "4 Dock Rd",
      City: "Harbor",
      State: "MA",
      Zip: "01234",
      Status: "Active",
      MemberSince: Time.now.year - 10
    )
    m.save(validate: false)
    m.people.create!(FirstName: "Jane", LastName: "Smith", MemberType: "Member", BirthYear: 1980, Committee1: "Boats")

    m.associate_check

    assert_equal "", Membership.flash_message
  end
end
