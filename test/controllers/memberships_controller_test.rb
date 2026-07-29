require "test_helper"

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership = memberships(:member2)
    @user = users(:three)
    @user.role = roles(:Membership)
    @user.save
    login_as @user, "passwor3"
  end

  test "should update if initiation installment amount is not blank" do
    attrs = @membership.attributes
    params = { membership: attrs }
    params[:membership][:initiation_installments_attributes] = { "0": { amount: 1000, year: 2022 } }
    put membership_path(@membership), params: params
    assert_redirected_to membership_path(@membership)
  end

  test "should not update if initiation installment amount is blank" do
    attrs = @membership.attributes
    params = { membership: attrs }
    params[:membership][:initiation_installments_attributes] = { "0": { amount: nil, year: 2022 } }
    put membership_path(@membership), params: params
    assert_redirected_to membership_path(@membership)
  end

  test "should update if boat name is not blank" do
    attrs = @membership.attributes
    params = { membership: attrs }
    params[:membership][:boats_attributes] = { "0": { Mfg_Size: nil, Name: "Hello" } }
    put membership_path(@membership), params: params
    assert_redirected_to membership_path(@membership)
  end

  test "should update if mfg/size is not blank" do
    attrs = @membership.attributes
    params = { membership: attrs }
    params[:membership][:boats_attributes] = { "0": { Mfg_Size: "SeaRay", Name: nil } }
    put membership_path(@membership), params: params
    assert_redirected_to membership_path(@membership)
  end

  # ==========================================
  # 1. Save Failure Tests (Native Minitest)
  # ==========================================

  test "save_association handles save failure gracefully" do
    boat = Boat.create!(Name: "Unassigned Boat", Mfg_Size: "Laser")

    # Force the instance to be invalid so @membership.save fails naturally
    @membership.LastName = nil
    @membership.save(validate: false)

    patch save_association_membership_path(@membership), params: { membership: { boats: boat.id } }

    assert_response :unprocessable_entity
    assert_equal "Error saving association.", flash[:alert]
  end

  test "unassign handles save failure gracefully" do
    @user.role = roles(:Admin)
    @user.save
    mooring = Mooring.create!(id: 999) rescue Mooring.first
    @membership.update_column(:mooring_id, mooring.id)
    @membership.LastName = nil
    @membership.save(validate: false)

    post unassign_membership_path(@membership)

    assert_redirected_to moorings_path
    assert_equal "Problem unassigning mooring ##{mooring.id}.", flash[:alert]
  end

  test "unassign_drysail handles save failure gracefully" do
    @user.role = roles(:Admin)
    @user.save
    drysail = Drysail.create!(spot_name: "Spot X") rescue Drysail.first
    @membership.drysail = drysail
    @membership.LastName = nil
    @membership.save(validate: false)

    post unassign_drysail_membership_path(@membership)

    assert_redirected_to drysails_path
    assert_equal "Problem unassigning dry sail spot ##{drysail.id}.", flash[:alert]
  end

  # ==========================================
  # 2. Complete Coverage for export_csv
  # ==========================================

  test "download_spreadsheet exports Member Card CSV" do
    post download_spreadsheet_memberships_path, params: { spreadsheet: "Member Cards/Workday Checklist" }

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.header["Content-Disposition"], "filename="
  end

  test "download_spreadsheet exports Resigned CSV" do
    post download_spreadsheet_memberships_path, params: { spreadsheet: "Resigned" }

    assert_response :success
    assert_equal "text/csv", response.media_type
  end

  test "download_spreadsheet exports Member List CSV" do
    post download_spreadsheet_memberships_path, params: { spreadsheet: "Member List" }

    assert_response :success
    assert_equal "text/csv", response.media_type
  end

  test "download_spreadsheet exports Log Fleet CSV" do
    post download_spreadsheet_memberships_path, params: { spreadsheet: "Log Fleet" }

    assert_response :success
    assert_equal "text/csv", response.media_type
  end

  test "download_spreadsheet exports Billing CSV (fallback branch)" do
    post download_spreadsheet_memberships_path, params: { spreadsheet: "Billing" }

    assert_response :success
    assert_equal "text/csv", response.media_type
  end

  test "download_spreadsheet redirects with error when an associate needs to be made active during Billing export" do
    # 1. Ensure flash message starts empty
    Membership.reset_flash_message

    # 2. Create an Associate membership eligible for Active status (triggers active_year <= Time.now.year + 1)
    m = Membership.new(
      LastName: "EligibleAssociate",
      MailingName: "Eligible Associate",
      StreetAddress: "123 Main St",
      City: "Burlington",
      State: "VT",
      Zip: "05401",
      Status: "Associate",
      MemberSince: Time.now.year - 6 # Meets threshold
    )
    m.save(validate: false)

    # Must create a child Person with MemberType 'Member' so active_year doesn't crash on .where().first
    m.people.create!(
      FirstName: "John",
      LastName: "EligibleAssociate",
      MemberType: "Member",
      BirthYear: 1980,
      Committee1: "Boats"
    )

    # 3. Call download_spreadsheet with "Billing"
    # This will trigger Membership.to_csv -> Membership.dues -> associate_check -> set_flash_message
    post download_spreadsheet_memberships_path, params: { spreadsheet: "Billing" }

    # 4. Assert redirect and flash[:error]
    assert_redirected_to spreadsheets_memberships_path
    assert_includes flash[:error], "Eligible Associate needs to be made Active"

    # Reset after test
    Membership.reset_flash_message
  end

  # ==========================================
  # 3. PDF Label Generator Edge Cases
  # ==========================================

  test "download_labels generates PDF for 'All' option" do
    post download_labels_memberships_path, params: { labels: "All" }

    assert_response :success
    assert_equal "application/pdf", response.media_type
  end

  test "download_labels generates PDF for 'No Email' option" do
    post download_labels_memberships_path, params: { labels: "No Email" }

    assert_response :success
    assert_equal "application/pdf", response.media_type
  end

  test "download_labels generates Workday PDF and handles long names/addresses" do
    # Create long mailing name with ' & ' and long street address with comma to trigger text split logic
    m = Membership.new(
      LastName: "VeryLongLastNameThatMightOver",
      MailingName: "Super Long First Person Name & Super Long Second Person Name That Wraps Over Line",
      StreetAddress: "123 Long Avenue Street Name, Apartment 4B Complex",
      City: "Burlington",
      State: "VT",
      Zip: "05401",
      Status: "Active",
      MemberSince: 2010
    )
    m.save(validate: false)

    post download_labels_memberships_path, params: { labels: "Workday" }

    assert_response :success
    assert_equal "application/pdf", response.media_type
  end

  test "download_labels covers mailing name split with ' and '" do
    m = Membership.new(
      LastName: "SplitTest",
      MailingName: "John Doe and Jane Doe Very Long Name That Triggers Width Split",
      StreetAddress: "123 Short St",
      City: "Burlington",
      State: "VT",
      Zip: "05401",
      Status: "Active",
      MemberSince: 2010
    )
    m.save(validate: false)

    post download_labels_memberships_path, params: { labels: "All" }

    assert_response :success
  end
end
