# app/jobs/update_members_job.rb
class UpdateMembersJob < ApplicationJob
  queue_as :default

  # Retries are essential when dealing with external APIs
  retry_on QboApi::ServiceUnavailable,
           QboApi::TooManyRequests,
           wait: :exponentially_longer,
           attempts: 5

  def perform
    config = QuickbooksConfig.first
    return unless config
    api = config.api_client

    Rails.logger.info "Starting processing to update members"

    qb_customers = api.all(:customer)

    # Map qb_customers to a hash for quick lookup
    existing_qbo_customers = qb_customers.index_by { |c| c["DisplayName"] }
    members = Membership.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)

    @update_count = 0
    member_count = 0
    create_count = 0
    members.each do |m|
      member_count += 1
      if existing_qbo_customers.key?(m.MailingName)
        update_member(api, existing_qbo_customers[m.MailingName], m)
      else
        create_member(api, m)
        create_count += 1
      end
    end
    Rails.logger.info "Finished, processed #{member_count} members, updated #{@update_count}, created #{create_count}"
  end

  private

  # Refactored update_member logic to be inside the job
  def update_member(api, qb_customer, membership)
    if address_or_email_changed?(qb_customer, membership)
      payload = build_customer_payload(membership)
      api.update(:customer, id: qb_customer["Id"], payload: payload)
      @update_count += 1
    end
  end

  def create_member(api, membership)
    payload = build_customer_payload(membership)
    api.create(:customer, payload: payload)
  rescue QboApi::BadRequest => e
    Rails.logger.error "Failed to create customer #{membership.MailingName}: #{e.message}"
  end

  def build_customer_payload(m)
    {
      DisplayName: m.MailingName,
      BillAddr: { Line1: m.StreetAddress, City: m.City, CountrySubDivisionCode: m.State, PostalCode: m.Zip },
      PrimaryEmailAddr: { Address: m.primary_email }
    }
  end

  def address_or_email_changed?(qbm, m)
    if qbm["PrimaryEmailAddr"] &&
       qbm["PrimaryEmailAddr"]["Address"] != m.primary_email
      logger.info "Email changed from %s to %s" % [ qbm["PrimaryEmailAddr"]["Address"], m.primary_email ]
      return true
    elsif qbm["BillAddr"].nil?
      logger.info "qbm[BillAddr].nil"
      return true
    elsif qbm["BillAddr"]["Line1"] != m.StreetAddress
      logger.info "Addr changed from %s to %s" % [ qbm["BillAddr"]["Line1"], m.StreetAddress ]
      return true
    elsif qbm["BillAddr"]["City"] != m.City
      logger.info "City changes from %s to %s" % [ qbm["BillAddr"]["City"], m.City ]
      return true
    elsif qbm["BillAddr"]["CountrySubDivisionCode"] != m.State
      logger.info "State changes from %s to %s" % [ qbm["BillAddr"]["CountrySubDivisionCode"], m.State ]
      return true
    elsif qbm["BillAddr"]["PostalCode"] != m.Zip
      logger.info "Zip changes from %s to %s" % [ qbm["BillAddr"]["PostalCode"], m.Zip ]
      return true
    end
    false
  end
end
