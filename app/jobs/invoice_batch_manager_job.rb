# app/jobs/invoice_batch_manager_job.rb
class InvoiceBatchManagerJob < ApplicationJob
  def perform(test)
    config = QuickbooksConfig.first
    return unless config # Handle case where config is missing
    @api = config.api_client

    # --- Cache Item IDs once ---
    item_map = {}
    item_names = [ "Dues", "Mooring Fee", "Mooring Replacement Fee", "Drysail Fee", "Initiation Installment", "Docks Assessment" ]

    # Fetch all items in one query
    items = @api.query("SELECT Id, Name FROM Item")
    items.each do |item|
      item_map[item["Name"]] = item["Id"] if item_names.include?(item["Name"])
    end

    members = test ? Membership.where(id: [ 64, 345 ]) : Membership.members.where('Status NOT IN ("Honorary", "Life")')

    failed_customers = []

    members.each do |m|
      customer_id = find_or_log_customer_id(m, failed_customers)
      next unless customer_id  # Skip if customer not found in QBO
      ProcessSingleInvoiceJob.set(queue: :invoices).perform_later(m.id, customer_id, item_map)
    end

    # Log a summary at the end
    if failed_customers.any?
      logger.error "Invoice Batch finished with #{failed_customers.size} failures: #{failed_customers.inspect}"
    end
  end

  def find_or_log_customer_id(membership, failed_customers)
    display_name = membership.MailingName
    begin
      query = "SELECT Id FROM Customer WHERE DisplayName = '#{display_name.gsub("'", "\\\\'")}'"
      results = @api.query(query)

      if results && results.any?
        results.first["Id"]
      else
        raise QboApi::NotFound
      end

    rescue QboApi::NotFound
      failed_customers << [ display_name, membership.id ]
      logger.warn "Customer not found in QuickBooks: #{display_name} (Membership ##{membership.id})"
      nil
    rescue QboApi::BadRequest => e
      failed_customers << [ display_name, membership.id ]
      logger.warn "Bad request for customer #{display_name}: #{e.message}"
      nil
    end
  end
end
