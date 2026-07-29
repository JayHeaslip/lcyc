require "test_helper"

class PersonTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @membership = memberships(:member1)
    @non_member = Membership.new
    @non_member.save(validate: false)
    @person = people(:bob)
  end

  # ==========================================
  # 1. Validations & Callbacks
  # ==========================================

  test "is valid with valid attributes" do
    assert @person.valid?
  end

  test "requires FirstName, LastName, and MemberType" do
    person = Person.new
    assert_not person.valid?
    assert_includes person.errors[:FirstName], "can't be blank"
    assert_includes person.errors[:LastName], "can't be blank"
    assert_includes person.errors[:MemberType], "can't be blank"
  end

  test "strips non-digits from phone numbers before validation" do
    @person.HomePhone = "(802) 555-1234"
    @person.CellPhone = "802-555-5678"
    @person.WorkPhone = "802.555.9012"

    assert @person.valid?
    assert_equal "8025551234", @person.HomePhone
    assert_equal "8025555678", @person.CellPhone
    assert_equal "8025559012", @person.WorkPhone
  end

  test "validates phone number length after stripping non-digits" do
    @person.HomePhone = "123-456" # Too short
    assert_not @person.valid?
    assert_includes @person.errors[:HomePhone], "is invalid"
  end

  test "validates email format when present" do
    @person.EmailAddress = "invalid_email_at_domain"
    assert_not @person.valid?
    assert_includes @person.errors[:EmailAddress], "is invalid"

    @person.EmailAddress = "valid.user@example.com"
    assert @person.valid?
  end

  test "validates birthyear for child member type" do
    child = Person.new(
      FirstName: "Timmy",
      LastName: "Doe",
      MemberType: "Child",
      membership: @membership
    )

    child.BirthYear = "999" # invalid 3 digits
    assert_not child.valid?
    assert_includes child.errors[:BirthYear], "is invalid"

    child.BirthYear = "2015"
    assert child.valid?
  end

  test "validates committee requirements based on membership status" do
    # Adult member on active status requires Committee1
    @person.Committee1 = nil
    assert_not @person.valid?
    assert_includes @person.errors[:Committee1], "can't be blank"

    # Children do not require Committee1
    child = Person.new(
      FirstName: "Lily",
      LastName: "Doe",
      MemberType: "Child",
      BirthYear: "2018",
      membership: @membership
    )
    assert child.valid?
  end

  # ==========================================
  # 2. Scopes
  # ==========================================

  test "search_by_keyword filters by first, last name or email" do
    @person.save!

    assert_includes Person.search_by_keyword("bob"), @person
    assert_includes Person.search_by_keyword("boblast"), @person
    assert_includes Person.search_by_keyword("bob@abc.com"), @person
    assert_empty Person.search_by_keyword("")
  end

  test "status scopes filter by membership status" do
    @person.save!

    assert_includes Person.members, @person
    assert_includes Person.active, @person
    assert_includes Person.has_committee, @person
    assert_not_includes Person.resigned, @person

    @membership.update!(Status: "Resigned")
    assert_includes Person.resigned, @person
    assert_not_includes Person.active, @person
  end

  test "valid_email and maillist scopes" do
    @person.assign_attributes(subscribe_general: true, EmailAddress: "valid@example.com")
    @person.save!

    assert_includes Person.valid_email, @person

    mail_person = Person.new(
      FirstName: "Subscriber",
      LastName: "Only",
      MemberType: "MailList",
      EmailAddress: "subscriber@example.com",
      subscribe_general: true,
      membership: @non_member
    )
    mail_person.save(validate: false)

    assert_includes Person.maillist, mail_person
  end

  # ==========================================
  # 3. Instance Methods
  # ==========================================

  test "<=> sorts Members before Partners and Children by BirthYear" do
    member = Person.new(MemberType: "Member")
    partner = Person.new(MemberType: "Partner")
    child_older = Person.new(MemberType: "Child", BirthYear: "2010")
    child_younger = Person.new(MemberType: "Child", BirthYear: "2015")

    assert_equal(-1, member <=> partner)
    assert_equal(1, partner <=> member)
    assert_equal(-1, child_older <=> child_younger)
    assert_equal(1, child_younger <=> child_older)
  end

  test "generate_email_hash creates SHA1 hash" do
    @person.save!
    @person.generate_email_hash

    expected_hash = Digest::SHA1.hexdigest("bob@abc.comweeble")
    assert_equal expected_hash, @person.email_hash
  end

  test "partner returns the matching spouse/partner full name" do
    @person.save!
    partner = Person.create!(
      FirstName: "Jane",
      LastName: "Doe",
      MemberType: "Partner",
      membership: @membership,
      Committee1: "Social"
    )

    assert_equal "Jane Doe", @person.send(:partner)
    assert_equal "bob boblast", partner.send(:partner)
  end

  test "remove_profile_picture purges attached picture when set to 1" do
    @person.save!
    @person.profile_picture.attach(
      io: StringIO.new("fake image data"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )

    assert @person.profile_picture.attached?

    assert_enqueued_jobs 1 do
      @person.remove_profile_picture = "1"
    end
  end

  test "display_photo returns a processed variant when profile_picture is attached" do
    @person.save!

    @person.profile_picture.attach(
      io: StringIO.new("fake image data"),
      filename: "avatar.jpg",
      content_type: "image/jpeg"
    )

    # Build the expected variant object
    expected_variant = @person.profile_picture.variant(
      resize_to_limit: [ 400, 400 ],
      format: :jpeg,
      quality: 85
    )

    # Stub .processed so Active Storage doesn't invoke system binaries (libvips)
    expected_variant.stub(:processed, expected_variant) do
      @person.profile_picture.stub(:variant, expected_variant) do
        photo = @person.display_photo

        assert_not_nil photo
        assert_equal :jpeg, photo.variation.transformations[:format]
        assert_equal [ 400, 400 ], photo.variation.transformations[:resize_to_limit]
        assert_equal 85, photo.variation.transformations[:quality]
      end
    end
  end

  test "display_photo returns nil when no profile_picture is attached" do
    assert_nil @person.display_photo
  end

  # ==========================================
  # 4. Class Methods & CSV Exports
  # ==========================================

  test "email_list returns correct collections based on arguments" do
    @person.assign_attributes(subscribe_general: true, select_email: true)
    @person.save!

    # Filtered mode
    assert_includes Person.email_list("All", true), @person

    # Committee mode
    assert_includes Person.email_list("Boats"), @person
  end

  test "to_csv generates CSV format for active members" do
    @person.save!

    csv_data = Person.to_csv
    assert_includes csv_data, "FirstName,LastName,MemberLastName,MailingName"
    assert_includes csv_data, "bob,boblast,Smith,Very Long Mailing Name & another long part,Active,Boats,2010,Member,,bob@abc.com"
  end

  test "email_list_to_csv exports simple recipient list" do
    @person.assign_attributes(subscribe_general: true)
    @person.save!

    csv_data = Person.email_list_to_csv
    assert_includes csv_data, "FirstName,LastName,Email"
    assert_includes csv_data, "bob,boblast,bob@abc.com"
  end

  test "resigned_to_csv generates CSV for resigned members" do
    @membership.update!(Status: "Resigned", resignation_date: Date.current)
    @person.save!

    csv_data = Person.resigned_to_csv
    assert_includes csv_data, "FirstName,LastName,MemberLastName,MailingName,Status,Comittee"
    assert_includes csv_data, "bob,boblast,Smith,Very Long Mailing Name & another long part,Resigned,Boats"
  end

  test "committee_spreadsheet generates committee member list CSV" do
    @person.save!

    csv_data = Person.committee_spreadsheet([ @person ])
    assert_includes csv_data, "LastName,FirstName,HomePhone,WorkPhone,CellPhone,EmailAddress,Committee"
    assert_includes csv_data, "boblast,bob,,,,bob@abc.com,Boats"
  end
end
