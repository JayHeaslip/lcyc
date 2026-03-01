class SendBulkAnnouncementJob < ApplicationJob
  queue_as :mailers   # or whatever queue you prefer

  def perform(mailing_id, person_ids, url_options)
    mailing = Mailing.find(mailing_id)
    host = url_options[:host]

    person_ids.in_groups_of(50, false) do |batch|
      batch.each do |person_id|
        person = Person.find_by(id: person_id)
        next unless person

        AnnouncementMailer.mailing(person.id, mailing_id, url_options, host)
          .deliver_now   # ← use deliver_now inside job
      rescue => e
        Rails.logger.error("Failed to send to person #{person_id}: #{e.message}")
      end
    end
  end
end
