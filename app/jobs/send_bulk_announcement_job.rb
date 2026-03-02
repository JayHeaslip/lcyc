# app/jobs/send_bulk_announcement_job.rb
require "net/smtp"  # Ensure this is loaded

class SendBulkAnnouncementJob < ApplicationJob
  limits_concurrency to: 1, duration: 30.seconds, key: "google_smtp_limit"

  queue_as :mailers

  def perform(mailing_id, person_ids, url_options, batch_size = 20)
    mailing = Mailing.find(mailing_id)

    # Take the first batch
    current_batch_ids = person_ids.shift(batch_size)
    remaining_ids = person_ids

    # Send the current batch
    send_batch(mailing_id, current_batch_ids, url_options)

    # If there are more people left, schedule the next batch in 30 seconds
    if remaining_ids.any?
      SendBulkAnnouncementJob.set(wait: 30.seconds).perform_later(
        mailing_id,
        remaining_ids,
        url_options,
        batch_size
      )
      Rails.logger.info("Scheduled next batch for Mailing #{mailing_id}. Remaining: #{remaining_ids.count}")
    else
      Rails.logger.info("Bulk mailing completed for Mailing #{mailing_id}")
    end
  end

  private

  def send_batch(mailing_id, batch_ids, url_options)
    smtp_settings = Rails.application.config.action_mailer.smtp_settings
    host = url_options[:host]

    smtp = Net::SMTP.new(smtp_settings[:address], smtp_settings[:port])
    smtp.enable_starttls_auto if smtp_settings[:enable_starttls_auto]

    smtp.start(
      smtp_settings[:domain] || "localhost",
      smtp_settings[:user_name],
      smtp_settings[:password],
      smtp_settings[:authentication] || :plain
    ) do |smtp_conn|
      batch_ids.each do |person_id|
        person = Person.find_by(id: person_id)
        next unless person

        begin
          mail = AnnouncementMailer.mailing(person.id, mailing_id, url_options, host)
          mail = mail.message if mail.respond_to?(:message)

          smtp_conn.send_message(mail.encoded, mail.from.first, mail.destinations)
        rescue => e
          Rails.logger.error("Failed to send to ID #{person_id}: #{e.message}")
        end
      end
    end
  end
end
