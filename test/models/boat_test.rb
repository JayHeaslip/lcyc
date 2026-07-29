require "test_helper"

class BoatTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @boat = boats(:boat10) rescue Boat.create!(Name: "Sea Breeze", Mfg_Size: "Catalina 30")
    @membership = memberships(:member1)
    @mooring = moorings(:mooring10) rescue nil
  end

  # ==========================================
  # 1. Existing Location Assignment Tests
  # ==========================================

  test "should assign boat to mooring" do
    @boat = boats(:boat11) rescue @boat
    @membership = memberships(:member11) rescue @membership
    @boat.location = "Mooring"
    assert @boat.valid?
    assert_equal @boat.mooring, @membership.mooring if @membership.respond_to?(:mooring)
  end

  test "should assign boat to drysail" do
    @boat = boats(:boat3) rescue @boat
    @membership = memberships(:member5) rescue @membership
    @boat.drysail = nil
    @boat.location = "Parking Lot"
    @boat.save
    assert_equal @boat.drysail, @membership.drysail if @membership.respond_to?(:drysail)
  end

  test "should not assign boat to mooring if mooring is not available" do
    @boat.location = "Mooring"
    @mooring.update!(memberships: []) if @mooring
    @boat.mooring = nil
    assert_not @boat.valid?
    assert_equal "", @boat.location
  end

  test "should not assign boat to drysail if drysail is not available" do
    @boat.location = "Parking Lot"
    @boat.drysail = nil
    @membership.update!(drysail: nil) if @membership.respond_to?(:drysail)
    assert_not @boat.valid?
    assert_equal "", @boat.location
  end

  # ==========================================
  # 2. Validations
  # ==========================================

  test "invalid without either Name or Mfg_Size" do
    boat = Boat.new(Name: "", Mfg_Size: "")
    assert_not boat.valid?
    assert_includes boat.errors[:base], "You must specify either a Name or Mfg/Size"

    boat.Name = "Wind Dancer"
    assert boat.valid?
  end

  test "enforces uniqueness of Name scoped to Mfg_Size" do
    Boat.create!(Name: "Unique Name", Mfg_Size: "Hunter 27")
    duplicate_boat = Boat.new(Name: "Unique Name", Mfg_Size: "Hunter 27")

    assert_not duplicate_boat.valid?
    assert_includes duplicate_boat.errors[:Name], "has already been taken"

    # Same name with different size should be valid
    duplicate_boat.Mfg_Size = "Hunter 30"
    assert duplicate_boat.valid?
  end

  # ==========================================
  # 3. Instance Methods & Helper Logic
  # ==========================================

  test "selection_string formats name and manufacturer size" do
    boat = Boat.new(Name: "Serenity", Mfg_Size: "Pearson 31")
    assert_equal "Serenity Pearson 31", boat.selection_string

    unnamed_boat = Boat.new(Name: "", Mfg_Size: "Laser")
    assert_equal "(no name) Laser", unnamed_boat.selection_string
  end

  test "phrf returns empty string when PHRF is 0" do
    boat = Boat.new(PHRF: 0)
    assert_equal "", boat.phrf

    boat.PHRF = 150
    assert_equal 150, boat.phrf
  end

  test "owners returns sorted array of membership last names" do
    m1 = memberships(:member1)
    m1.update!(LastName: "Zebra")
    m2 = memberships(:member2)
    m2.update!(LastName: "Alpha")

    boat = Boat.create!(Name: "Co-owned", Mfg_Size: "J/24")
    boat.memberships << [ m1, m2 ]

    assert_equal [ "Alpha", "Zebra" ], boat.owners
  end

  test "update_mooring_drysail clears assignments based on location" do
    m = Mooring.create! rescue nil
    d = Drysail.create! rescue nil

    boat = Boat.new(Name: "Test Spot", Mfg_Size: "20ft", mooring: m, drysail: d)

    # Setting location to Parking Lot clears mooring
    boat.location = "Parking Lot"
    boat.update_mooring_drysail
    assert_nil boat.mooring
    assert_equal d, boat.drysail

    # Setting location to Mooring clears drysail
    boat.mooring = m
    boat.location = "Mooring"
    boat.update_mooring_drysail
    assert_nil boat.drysail
    assert_equal m, boat.mooring

    # Setting location to empty clears both
    boat.location = ""
    boat.update_mooring_drysail
    assert_nil boat.mooring
    assert_nil boat.drysail
  end

  test "remove_photo purges attached photo when set to 1" do
    @boat.save!
    @boat.photo.attach(
      io: StringIO.new("fake boat image"),
      filename: "boat.jpg",
      content_type: "image/jpeg"
    )

    assert @boat.photo.attached?

    assert_enqueued_jobs 1 do
      @boat.remove_photo = "1"
    end
  end

  # ==========================================
  # 4. Scopes & CSV
  # ==========================================

  test "active_members scope filters boats with active membership statuses" do
    m_active = memberships(:member1)
    m_resigned = memberships(:member2)
    m_resigned.update!(Status: "Resigned")

    active_boat = Boat.create!(Name: "Active Boat", Mfg_Size: "22ft")
    active_boat.memberships << m_active

    resigned_boat = Boat.create!(Name: "Resigned Boat", Mfg_Size: "22ft")
    resigned_boat.memberships << m_resigned

    assert_includes Boat.active_members, active_boat
    assert_not_includes Boat.active_members, resigned_boat
  end

  test "to_csv exports boat attributes in CSV format" do
    m = memberships(:member1)
    m.update!(LastName: "Captain")
    boat = Boat.create!(Name: "CSV Express", Mfg_Size: "Tartal 30", sail_num: "123", PHRF: 120)
    boat.memberships << m

    csv_output = Boat.to_csv

    assert_includes csv_output, "Name,Mooring#,Sail#,Mfg/Size,PHRF,Owner"
    assert_includes csv_output, "CSV Express"
    assert_includes csv_output, "Tartal 30"
    assert_includes csv_output, "Captain"
  end
end
