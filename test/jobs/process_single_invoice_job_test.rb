# test/jobs/process_single_invoice_job_test.rb
require "test_helper"

class ProcessSingleInvoiceJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    @membership = memberships(:member1)
    @customer_id = "qbo_customer_99"
    @item_map = {
      "Dues" => "item_1",
      "Mooring Fee" => "item_2",
      "Mooring Replacement Fee" => "item_3",
      "Drysail Fee" => "item_4",
      "Initiation Installment" => "item_5",
      "Docks Assessment" => "item_6"
    }

    # Standard Mock setup for QuickbooksConfig and API client
    @mock_api = Minitest::Mock.new
    @config = QuickbooksConfig.new
  end

  test "queues the job on the invoices queue" do
    assert_enqueued_with(job: ProcessSingleInvoiceJob, queue: "invoices") do
      ProcessSingleInvoiceJob.perform_later(@membership.id, @customer_id, @item_map)
    end
  end

  test "performs successfully and creates invoice in QBO" do
    Membership.stub :dues, 500, [@membership] do
      @membership.stub :calculate_mooring_fee, 150 do
        @membership.stub :calculate_mooring_replacement_fee, 0 do
          @membership.stub :calculate_drysail_fee, 0 do
            @membership.stub :calculate_initiation_installment, 0 do
              @membership.stub :calculate_docks_assessment, 0 do
                
                expected_payload = {
                  CustomerRef: { value: @customer_id },
                  AllowOnlineACHPayment: true,
                  DueDate: "#{Time.current.year}-12-31",
                  BillEmail: { Address: @membership.primary_email },
                  BillEmailCc: { Address: @membership.cc_email },
                  "Line" => [
                    {
                      Amount: 500,
                      Description: nil,
                      DetailType: "SalesItemLineDetail",
                      SalesItemLineDetail: { ItemRef: { value: "item_1", name: "Dues" } }
                    },
                    {
                      Amount: 150,
                      Description: "Mooring ##{@membership.mooring&.id}",
                      DetailType: "SalesItemLineDetail",
                      SalesItemLineDetail: { ItemRef: { value: "item_2", name: "Mooring Fee" } }
                    }
                  ]
                }
                
                # Note the keyword argument `payload:` passed outside the positional args array:
                @mock_api.expect :create, { "Id" => "101" }, [:invoice], payload: expected_payload
                
                QuickbooksConfig.stub :first, @config do
                  @config.stub :api_client, @mock_api do
                    Membership.stub :find, @membership, [@membership.id] do
                      ProcessSingleInvoiceJob.perform_now(@membership.id, @customer_id, @item_map)
                    end
                  end
                end
                
                assert @mock_api.verify
              end
            end
          end
        end
      end
    end
  end

  test "returns gracefully when QuickbooksConfig is missing" do
    QuickbooksConfig.stub :first, nil do
      # Make sure job doesn't raise an unhandled exception
      assert_nothing_raised do
        ProcessSingleInvoiceJob.perform_now(@membership.id, @customer_id, @item_map)
      end
    end
  end
end
