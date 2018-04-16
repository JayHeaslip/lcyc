#needed for number_to_currency
include ActionView::Helpers::NumberHelper

class MailRobot < ApplicationMailer

  def confirmation_email(user, hash, host)
    @url = "#{host}confirm_email/#{hash}"
    mail(to: user.email, subject: 'Confirm LCYC registration')
  end

  def newpw_email(user, host)
    @url = "#{host}rp/#{user.reset_password_code}"
    mail(to: user.email, subject: 'Password reset for LCYC')
  end

  def mailing(person, mailing, host)
    mailing = Mailing.find(mailing)
    @content = mailing.body
    filenames = mailing.attachments.map { |a| a.pdf.url(:original, false)}
    @url = "#{host}unsubscribe/#{person.email_hash}"
    filenames.each do |f|
      attachments[File.basename(f)] = File.read("#{Rails.root}/public/#{f}")
    end
    mail(to: person.EmailAddress,
         from: 'LCYC Announcements <lcyc@members.lcyc.info>',
         reply_to: mailing.replyto,
         subject: '[LCYC] ' + mailing.subject)
  end

  def send_bills(email, replyto, mailingname, status, mooring, dues, fees, mooring_maint_fee, initiation)
    @mailingname = mailingname
    @email = email
    @status = status
    @mooring = mooring
    @dues = number_to_currency(dues).rjust(10)
    @fees = number_to_currency(fees).rjust(10)
    @mooring_maint_fee = number_to_currency(mooring_maint_fee).rjust(10)
    @initiation = initiation
    @total = number_to_currency(dues + fees + mooring_maint_fee + initiation).rjust(10)
    mail(to: email,
         from: 'LCYC Announcements <lcyc@members.lcyc.info>',
         reply_to: replyto,
         subject: '[LCYC] ' + 'Annual Dues')
  end

  def dbbackup(backup)
    attachments["sqldump.sql.gz"] = File.read(backup)
    mail(to: 'lcycadmin@gmail.com', subject: 'Database backup')
  end

end
