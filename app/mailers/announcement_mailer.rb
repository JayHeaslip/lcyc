class AnnouncementMailer < ApplicationMailer
  def mailing(person_id, mailing_id, url_options, host)
    ActiveStorage::Current.url_options = url_options

    @person  = Person.find(person_id)
    @mailing = Mailing.find(mailing_id)

    tag = "[LCYC] "

    @url     = "#{host}unsubscribe/#{@person.email_hash}"
    @content = @mailing.content.body   # assuming .content is a rich text field or similar

    # Attach PDFs here — this runs in the background job, so safe to download blobs
    @mailing.pdfs.each do |pdf|
      begin
        attachments[pdf.filename.to_s] = pdf.download
      rescue ActiveStorage::FileNotFoundError, ActiveRecord::RecordNotFound => e
        Rails.logger.error("Failed to attach PDF #{pdf.id}: #{e.message}")
        # Optionally notify yourself/Sentry, but don't fail the whole email
      end
    end

    mail(
      to:       @person.EmailAddress,   # note: your original had .EmailAddress — assuming that's the accessor
      from:     "LCYC Announcements <lcyc@members.lcyc.info>",
      reply_to: @mailing.replyto,
      subject:  tag + @mailing.subject
    )
  end
end
