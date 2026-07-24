# test/jobs/invoice_batch_manager_job_test.rb
require "test_helper"

class InvoiceBatchManagerJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    @config = QuickbooksConfig.new
    @mock_api = Minitest::Mock.new

    @member_1 = memberships(:member1) # Fixture or Factory record
    @member_2 = memberships(:member2)

    @qbo_items_response = [
      { "Id" => "item_1", "Name" => "Dues" },
      { "Id" => "item_2", "Name" => "Mooring Fee" }
    ]

    @item_map = {
      "Dues" => "item_1",
      "Mooring Fee" => "item_2"
    }
  end

  test "returns early if QuickbooksConfig is missing" do
    QuickbooksConfig.stub :first, nil do
      assert_nothing_raised do
        InvoiceBatchManagerJob.perform_now(false)
      end
    end
  end

  test "enqueues ProcessSingleInvoiceJob for filtered members in test mode" do
    members_relation = [@member_1]

    # Mock QBO query for Item IDs
    @mock_api.expect :query, @qbo_items_response, ["SELECT Id, Name FROM Item"]

    # Mock QBO query for Customer lookup
    customer_query = "SELECT Id FROM Customer WHERE DisplayName = '#{@member_1.MailingName.gsub("'", "\\\\'")}'"
    @mock_api.expect :query, [{ "Id" => "qbo_cust_123" }], [customer_query]

    QuickbooksConfig.stub :first, @config do
      @config.stub :api_client, @mock_api do
        Membership.stub :where, members_relation, [{ id: [64, 345] }] do
          
          # Verify that ProcessSingleInvoiceJob is enqueued with expected args
          assert_enqueued_with(
            job: ProcessSingleInvoiceJob,
            args: [@member_1.id, "qbo_cust_123", @item_map],
            queue: "invoices"
          ) do
            InvoiceBatchManagerJob.perform_now(true) # test = true
          end

        end
      end
    end

    assert @mock_api.verify
  end

  test "logs warning and skips enqueuing when QBO customer is not found" do
    # Mock QBO query for Item IDs
    @mock_api.expect :query, @qbo_items_response, ["SELECT Id, Name FROM Item"]

    # Mock QBO query returning no results for Customer lookup
    customer_query = "SELECT Id FROM Customer WHERE DisplayName = '#{@member_1.MailingName.gsub("'", "\\\\'")}'"
    @mock_api.expect :query, [], [customer_query]

    QuickbooksConfig.stub :first, @config do
      @config.stub :api_client, @mock_api do
        Membership.stub :where, [@member_1], [{ id: [64, 345] }] do
          
          # Ensure NO child jobs get enqueued
          assert_no_enqueued_jobs(only: ProcessSingleInvoiceJob) do
            InvoiceBatchManagerJob.perform_now(true)
          end

        end
      end
    end

    assert @mock_api.verify
  end

  test "handles QboApi::BadRequest when looking up customer" do
    @mock_api.expect :query, @qbo_items_response, ["SELECT Id, Name FROM Item"]

    customer_query = "SELECT Id FROM Customer WHERE DisplayName = '#{@member_1.MailingName.gsub("'", "\\\\'")}'"
    
    # Pass a block to expect — Minitest executes this block when @mock_api.query is called
    @mock_api.expect(:query, nil) do |q|
      raise QboApi::BadRequest.new({})
    end

    QuickbooksConfig.stub :first, @config do
      @config.stub :api_client, @mock_api do
        Membership.stub :where, [@member_1], [{ id: [64, 345] }] do
          
          assert_no_enqueued_jobs(only: ProcessSingleInvoiceJob) do
            assert_nothing_raised do
              InvoiceBatchManagerJob.perform_now(true)
            end
          end

        end
      end
    end

    assert @mock_api.verify
  end
end
