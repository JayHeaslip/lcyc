# app/jobs/process_single_invoice_job.rb
class ProcessSingleInvoiceJob < ApplicationJob
  queue_as :invoices

  retry_on QboApi::ServiceUnavailable,
           QboApi::TooManyRequests,
           wait: :exponentially_longer,
           attempts: 5

  # Best practice: Pass the ID, not the ActiveRecord object
  def perform(member_id, customer_id, item_map)
    @membership = Membership.find(member_id)
    @item_map = item_map

    config = QuickbooksConfig.first
    return unless config # Handle case where config is missing
    @api = config.api_client

    Rails.logger.info "Generate invoice for #{@membership.MailingName}"
    @api.create(:invoice, payload: build_invoice(customer_id))
  end

  private

  def build_invoice(customer_id)
    invoice = {
      CustomerRef: { value: customer_id },
      AllowOnlineACHPayment: true,
      DueDate: "#{Time.now.year}-12-31",
      BillEmail: { Address: @membership.primary_email },
      BillEmailCc: { Address: @membership.cc_email }
    }
    invoice["Line"] = generate_line_items(@membership)
    invoice
  end

  def generate_line_items(m)
    line_items = []

    # Helper to dry up the item lookup and amount logic
    add_line_item(line_items, m, :dues, "Dues")
    add_line_item(line_items, m, :calculate_mooring_fee, "Mooring Fee", "Mooring ##{m.mooring&.id}")
    add_line_item(line_items, m, :calculate_mooring_replacement_fee, "Mooring Replacement Fee", "Mooring ##{m.mooring&.id}")
    add_line_item(line_items, m, :calculate_drysail_fee, "Drysail Fee")
    add_line_item(line_items, m, :calculate_initiation_installment, "Initiation Installment")
    add_line_item(line_items, m, :calculate_docks_assessment, "Docks Assessment")

    line_items
  end

  def add_line_item(items, member, method, qbo_item_name, description = nil)
    # Call the dues method on Membership class or the calc methods on the instance
    amount = method == :dues ? Membership.dues(member) : member.send(method)
    amount ||= 0

    if amount != 0
      # Item lookup: QBO needs the ID of the 'Product/Service'
      item_id = @item_map[qbo_item_name]

      items << {
        Amount: amount,
        Description: description,
        DetailType: "SalesItemLineDetail",
        SalesItemLineDetail: {
          ItemRef: { value: item_id, name: qbo_item_name }
        }
      }
    end
  end
end
