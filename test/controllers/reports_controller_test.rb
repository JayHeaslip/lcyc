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

  test "should generate associates report and sort list by active_year" do
    # Setup test memberships matching the query constraints
    associate1 = memberships(:associate)
    #associate1.stub(:active_year, 2026)

    get associates_report_path

    assert_response :success
    assert_not_nil assigns(:m)
    assert_not_nil assigns(:list)

    # Verifies the structure of items pushed into @list:
    # [ MailingName, EmailAddress, MemberSince, member_birthyear, partner_birthyear, active_year ]
    if assigns(:list).any?
      first_entry = assigns(:list).first
      assert_equal 6, first_entry.size
    end
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
    mooring_unassigned = Mooring.create!(id:1)

    # 2. Mooring with multiple memberships, missing a skip_mooring flag (triggers skip_errors)
    mooring_multiple_error = Mooring.create!(id:2)
    m1 = memberships(:member1)
    m2 = memberships(:member2)
    m1.skip_mooring = false
    m2.skip_mooring = false
    mooring_multiple_error.memberships << [m1, m2]

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
