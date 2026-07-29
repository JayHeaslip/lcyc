require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_user = User.create!(
      firstname: "bob",
      lastname: "bob",
      email: "confirmed_user@example.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.current,
      role: roles(:BOG)
    )

    login @confirmed_user
  end

  # --- 1. SUMMARY ACTION ---

  test "should generate summary report and calculate non-filtered totals" do
    get summary_report_path

    assert_response :success
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:total)

    # Verifies excluded statuses were removed from @categories
    refute_includes assigns(:categories).keys, "Resigned"
    refute_includes assigns(:categories).keys, "Deceased"
    refute_includes assigns(:categories).keys, "Affiliated"
    refute_includes assigns(:categories).keys, "Non-member"

    assert_equal assigns(:categories).values.sum, assigns(:total)
  end

  # --- 2. SUBSCRIPTION LIST ACTION ---

  test "should generate and download subscription_list CSV file" do
    # Stub Person.email_list_to_csv to return predictable CSV data
    Person.stub :email_list_to_csv, "Email,Name\ntest@example.com,Test User" do
      get subscription_list_path
    end

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers["Content-Disposition"], "subscription_list_"
    assert_includes response.headers["Content-Disposition"], ".csv"
    assert_equal "Email,Name\ntest@example.com,Test User", response.body
  end

# --- 3. ASSOCIATES ACTION ---

  test "should generate associates report, process members and partners, and sort by active_year" do
    # Cleanup any existing Associate records in fixtures to keep test deterministic
    Membership.where(Status: "Associate").destroy_all

    # Associate 1: Has a higher active_year (should sort second)
    assoc1 = Membership.new(
      LastName: "Baker",
      MailingName: "Bob & Betty Baker",
      StreetAddress: "10 Main St",
      City: "Boston",
      State: "MA",
      Zip: "02108",
      Status: "Associate",
      MemberSince: 2020,
      active_date: Time.zone.parse("2020-01-01")
    )
    assoc1.save(validate: false)
    assoc1.people.create!(
      FirstName: "Bob",
      LastName: "Baker",
      MemberType: "Member",
      EmailAddress: "bob@example.com",
      BirthYear: 1980,
      Committee1: "Boats"
    )
    assoc1.people.create!(
      FirstName: "Betty",
      LastName: "Baker",
      MemberType: "Partner",
      EmailAddress: "betty@example.com",
      BirthYear: 1982,
      Committee1: "Social"
    )

    # Associate 2: Has a lower active_year (should sort first)
    assoc2 = Membership.new(
      LastName: "Adams",
      MailingName: "Alice Adams",
      StreetAddress: "20 Oak St",
      City: "Boston",
      State: "MA",
      Zip: "02108",
      Status: "Associate",
      MemberSince: 2015,
      active_date: Time.zone.parse("2015-01-01")
    )
    assoc2.save(validate: false)
    assoc2.people.create!(
      FirstName: "Alice",
      LastName: "Adams",
      MemberType: "Member",
      EmailAddress: "alice@example.com",
      BirthYear: 1970,
      Committee1: "Social"
    )

    # Non-associate membership (should be excluded)
    Membership.create!(
      LastName: "ActiveMember",
      MailingName: "Active Member",
      StreetAddress: "30 Pine St",
      City: "Boston",
      State: "MA",
      Zip: "02108",
      Status: "Active",
      MemberSince: 2010,
      active_date: Time.zone.parse("2010-01-01"),
      people_attributes: [ { FirstName: "Charlie", LastName: "ActiveMember", MemberType: "Member", Committee1: "Boats" } ]
    )

    get associates_report_path

    assert_response :success
    assert_not_nil assigns(:m)
    assert_not_nil assigns(:list)

    list = assigns(:list)
    assert_equal 2, list.size

    # Verify elements for assoc2 (Alice Adams)
    first_entry = list.first
    assert_equal "Alice Adams", first_entry[0]        # MailingName
    assert_equal "alice@example.com", first_entry[1]   # Member EmailAddress
    assert_equal 2015, first_entry[2]                 # MemberSince
    assert_equal 1970, first_entry[3]                 # member_birthyear
    assert_nil first_entry[4]                         # partner_birthyear (no partner)
    assert_equal assoc2.active_year, first_entry[5]   # active_year

    # Verify elements for assoc1 (Bob & Betty Baker)
    second_entry = list.second
    assert_equal "Bob & Betty Baker", second_entry[0]
    assert_equal "bob@example.com", second_entry[1]
    assert_equal 2020, second_entry[2]
    assert_equal 1980, second_entry[3]
    assert_equal 1982, second_entry[4]                # partner_birthyear present
    assert_equal assoc1.active_year, second_entry[5]

    # Verify sorting order: first item's active_year must be <= second item's active_year
    assert list.first[5] <= list.second[5], "List is not sorted by active_year in ascending order"
  end

  # --- 4. HISTORY ACTION ---

  test "should generate history report and group membership status by year" do
    fake_memberships = [
      Membership.new(Status: "Accepted", created_at: Time.zone.parse("2021-05-01")),
      Membership.new(Status: "Active", active_date: Time.zone.parse("2022-06-01")),
      Membership.new(Status: "Resigned", resignation_date: Time.zone.parse("2023-01-01")),
      Membership.new(Status: "Deceased", updated_at: Time.zone.parse("2024-02-01")),
      Membership.new(Status: "Senior", change_status_date: Time.zone.parse("2025-03-01"))
    ]

    get history_report_path

    assert_response :success
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:dates)

    # Verify 'Deceased' was mapped to 'Resigned' in the @categories hash
    assert_includes assigns(:categories).keys, "Resigned"
    refute_includes assigns(:categories).keys, "Deceased"

    # Verify @dates array is sorted and unique
    assert_equal assigns(:dates), assigns(:dates).uniq.sort
  end

  # --- 5. MOORINGS ACTION ---

  test "should generate moorings report and identify unassigned, multiple, and skip error moorings" do
    # 1. Unassigned mooring
    mooring_unassigned = Mooring.create!(id: 1)

    # 2. Mooring with multiple memberships, missing a skip_mooring flag (triggers skip_errors)
    mooring_multiple_error = Mooring.create!(id: 2)
    m1 = memberships(:member1)
    m2 = memberships(:member2)
    m1.skip_mooring = false
    m2.skip_mooring = false
    mooring_multiple_error.memberships << [ m1, m2 ]

    # 3. Mooring with a single membership that has skip_mooring set to true (triggers skip_errors)
    mooring_single_skip_error = Mooring.create!
    m3 = memberships(:member3)
    m3.skip_mooring = true
    mooring_single_skip_error.memberships << m3

    get moorings_report_path

    assert_response :success
    assert_not_nil assigns(:unassigned)
    assert_not_nil assigns(:skip_errors)
    assert_not_nil assigns(:multiple_memberships)

    # Verify IDs are categorized into the appropriate instance variables
    assert_includes assigns(:unassigned), mooring_unassigned.id
    assert_includes assigns(:multiple_memberships), mooring_multiple_error.id
    assert_includes assigns(:skip_errors), mooring_multiple_error.id
    assert_includes assigns(:skip_errors), mooring_single_skip_error.id
  end
end
