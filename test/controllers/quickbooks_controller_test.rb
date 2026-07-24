require "test_helper"

class QuickbooksControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    admin = users(:one)
    login_as(admin, "aqswde12$$") # adjust password helper as needed

    # Ensure a valid config exists for routes protected by check_qb_connection
    @config = QuickbooksConfig.create!(
      access_token: "test_token",
      refresh_token: "test_refresh",
      realm_id: "123456",
      access_token_expires_at: 1.hour.from_now
    )
  end

  # ==========================================
  # 1. Connection & OAuth Actions
  # ==========================================

  test "connect redirects to QuickBooks authorization URL" do
    get connect_quickbooks_path
    assert_response :redirect
    assert_not_nil session[:state]
    assert_includes response.redirect_url, "intuit.com" # or OAuth provider host
  end

  # ==========================================
  # OAuth Callback (`new` action)
  # ==========================================

  test "oauth callback fails when session state does not match state param" do
    # Initiate flow to populate session[:state]
    get connect_quickbooks_path

    get new_quickbook_path, params: {
      code: "valid_code",
      state: "invalid_state",
      error: "invalid_grant",
      realmId: "123456"
    }

    assert_redirected_to root_path
    assert_equal "Error: invalid_grant", flash[:alert]
  end

  test "oauth callback successfully exchanges code and saves config" do
    get connect_quickbooks_path
    matching_state = session[:state]

    mock_token_resp = Struct.new(:access_token, :refresh_token, :expires_in).new(
      "access_123",
      "refresh_456",
      3600
    )

    mock_client = Minitest::Mock.new
    mock_client.expect :authorization_code=, nil, ["valid_code"]
    mock_client.expect :access_token!, mock_token_resp

    mock_config_instance = Minitest::Mock.new
    mock_config_instance.expect :oauth2_client, mock_client

    # Stub QuickbooksConfig.new to return our mock instance
    QuickbooksConfig.stub :new, mock_config_instance do
      get new_quickbook_path, params: {
        code: "valid_code",
        state: matching_state,
        realmId: "realm_789"
      }
    end

    assert mock_client.verify
    assert mock_config_instance.verify
    assert_redirected_to invoices_quickbooks_path
    assert_equal "QuickBooks connected successfully.", flash[:notice]

    # Verify DB update
    config = QuickbooksConfig.first
    assert_equal "access_123", config.access_token
    assert_equal "refresh_456", config.refresh_token
    assert_equal "realm_789", config.realm_id
  end

  test "oauth callback handles failed token exchange" do
    get connect_quickbooks_path
    matching_state = session[:state]

    mock_client = Minitest::Mock.new
    mock_client.expect :authorization_code=, nil, ["invalid_code"]
    mock_client.expect :access_token!, nil

    mock_config_instance = Minitest::Mock.new
    mock_config_instance.expect :oauth2_client, mock_client

    # Stub QuickbooksConfig.new to return our mock instance
    QuickbooksConfig.stub :new, mock_config_instance do
      get new_quickbook_path, params: {
        code: "invalid_code",
        state: matching_state,
        realmId: "realm_789"
      }
    end

    assert mock_client.verify
    assert mock_config_instance.verify
    assert_redirected_to root_path
    assert_equal "Something went wrong. Try the process again.", flash[:alert]
  end

  # ==========================================
  # 2. Before Action: check_qb_connection
  # ==========================================

  test "redirects to connect route when QuickbooksConfig does not exist" do
    QuickbooksConfig.destroy_all

    get invoices_quickbooks_path
    assert_redirected_to connect_quickbooks_path
    assert_equal "Please connect to QuickBooks first.", flash[:alert]
  end

  test "redirects to connect route when access_token is blank" do
    # Clear out any existing fixture records first
    QuickbooksConfig.destroy_all
    QuickbooksConfig.create!(access_token: "")

    get invoices_quickbooks_path
    assert_redirected_to connect_quickbooks_path
    assert_equal "Please connect to QuickBooks first.", flash[:alert]
  end

  # ==========================================
  # 3. Invoices & Cleanup Filter
  # ==========================================

  test "invoices action cleans up leading and trailing whitespace on memberships" do
    # Ensure this member matches Membership.billed_members scope
    member = memberships(:member1)
    
    # Use fields with plenty of VARCHAR capacity (avoiding State VARCHAR(2) limits)
    member.update_columns(
      MailingName: "  Jane Doe  ",
      StreetAddress: " 123 Main St ",
      City: " Burlington "
    )

    get invoices_quickbooks_path
    assert_response :success

    member.reload
    assert_equal "Jane Doe", member.MailingName
    assert_equal "123 Main St", member.StreetAddress
    assert_equal "Burlington", member.City
  end

  # ==========================================
  # 4. Generate Invoices & Background Jobs
  # ==========================================

  test "generate_invoices enqueues jobs and redirects with notice" do
    assert_enqueued_with(job: UpdateMembersJob) do
      post generate_invoices_quickbooks_path, params: { test: "true" }
    end

    assert_enqueued_with(job: InvoiceBatchManagerJob, args: ["true"])
    assert_redirected_to root_path
    assert_equal "Generating invoices, check quickbooks in about 15 minutes", flash[:notice]
  end
end
