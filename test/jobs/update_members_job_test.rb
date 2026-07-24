# test/jobs/update_members_job_test.rb
require "test_helper"

class UpdateMembersJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    @config = QuickbooksConfig.new
    @mock_api = Minitest::Mock.new

    @member = memberships(:member1)
    @person = people(:bob)
    @member.update!(
      StreetAddress: "123 Main St",
      City: "Burlington",
      State: "VT",
      Zip: "05401",
    )

    @expected_payload = {
      DisplayName: @member.MailingName,
      BillAddr: {
        Line1: "123 Main St",
        City: "Burlington",
        CountrySubDivisionCode: "VT",
        PostalCode: "05401"
      },
      PrimaryEmailAddr: { Address: @person.EmailAddress }
    }

    # Standard QBO customer payload matching @member exactly
    @matching_qb_customer = {
      "Id" => "qbo_99",
      "DisplayName" => @member.MailingName,
      "PrimaryEmailAddr" => { "Address" => @person.EmailAddress },
      "BillAddr" => {
        "Line1" => "123 Main St",
        "City" => "Burlington",
        "CountrySubDivisionCode" => "VT",
        "PostalCode" => "05401"
      }
    }
  end

  # ==========================================
  # 1. Early Return & Missing Config
  # ==========================================

  test "returns early if QuickbooksConfig is missing" do
    QuickbooksConfig.stub :first, nil do
      assert_nothing_raised do
        UpdateMembersJob.perform_now
      end
    end
  end

  # ==========================================
  # 2. Member Creation & Error Handling
  # ==========================================

  test "creates customer in QBO when member does not exist in QBO" do
    @mock_api.expect :all, [], [:customer]
    @mock_api.expect :create, { "Id" => "qbo_1" }, [:customer], payload: @expected_payload

    stub_job_dependencies([@member]) do
      UpdateMembersJob.perform_now
    end

    assert @mock_api.verify
  end

  test "rescues and logs QboApi::BadRequest on creation error without failing job" do
    @mock_api.expect :all, [], [:customer]
    @mock_api.expect(:create, nil) do |*_args, **_kwargs|
      raise QboApi::BadRequest.new({})
    end

    stub_job_dependencies([@member]) do
      assert_nothing_raised do
        UpdateMembersJob.perform_now
      end
    end

    assert @mock_api.verify
  end

  # ==========================================
  # 3. Address & Email Change Logic Branching
  # ==========================================

  test "skips update when customer details are completely unchanged" do
    @mock_api.expect :all, [@matching_qb_customer], [:customer]

    stub_job_dependencies([@member]) do
      UpdateMembersJob.perform_now
    end

    assert @mock_api.verify
  end

  test "updates customer when email changes" do
    customer = @matching_qb_customer.deep_merge("PrimaryEmailAddr" => { "Address" => "old@example.com" })
    assert_trigges_update(customer)
  end

  test "updates customer when BillAddr is nil in QBO" do
    customer = @matching_qb_customer.dup
    customer["BillAddr"] = nil
    assert_trigges_update(customer)
  end

  test "updates customer when street address (Line1) changes" do
    customer = @matching_qb_customer.deep_merge("BillAddr" => { "Line1" => "999 Old St" })
    assert_trigges_update(customer)
  end

  test "updates customer when City changes" do
    customer = @matching_qb_customer.deep_merge("BillAddr" => { "City" => "Old City" })
    assert_trigges_update(customer)
  end

  test "updates customer when State (CountrySubDivisionCode) changes" do
    customer = @matching_qb_customer.deep_merge("BillAddr" => { "CountrySubDivisionCode" => "NY" })
    assert_trigges_update(customer)
  end

  test "updates customer when Zip (PostalCode) changes" do
    customer = @matching_qb_customer.deep_merge("BillAddr" => { "PostalCode" => "00000" })
    assert_trigges_update(customer)
  end

  # ==========================================
  # 4. Job Retry Behavior
  # ==========================================

  test "retries job when QboApi::ServiceUnavailable is raised" do
    assert_retried_on_exception(QboApi::ServiceUnavailable.new({}))
  end

  test "retries job when QboApi::TooManyRequests is raised" do
    assert_retried_on_exception(QboApi::TooManyRequests.new({}))
  end

  private

  def assert_trigges_update(qbo_customer)
    @mock_api.expect :all, [qbo_customer], [:customer]
    @mock_api.expect :update, { "Id" => qbo_customer["Id"] }, [:customer], id: qbo_customer["Id"], payload: @expected_payload

    stub_job_dependencies([@member]) do
      UpdateMembersJob.perform_now
    end

    assert @mock_api.verify
  end

  def assert_retried_on_exception(exception)
    @mock_api.expect(:all, nil) { raise exception }
    
    stub_job_dependencies([@member]) do
      assert_enqueued_with(job: UpdateMembersJob) do
        job = UpdateMembersJob.new
        job.stub(:determine_delay, 5) do # <-- Replaces job.executions = 1
          job.perform_now
        end
      end
    end
  end

  def stub_job_dependencies(members_list, &block)
    mock_relation = Minitest::Mock.new
    mock_relation.expect :includes, members_list, [:people]

    Membership.stub :members, Membership do
      Membership.stub :where, mock_relation do
        QuickbooksConfig.stub :first, @config do
          @config.stub :api_client, @mock_api do
            yield
          end
        end
      end
    end
  end
end
