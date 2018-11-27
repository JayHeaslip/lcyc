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

  def mailing(person, mailing, host, filtered = nil)
    mailing = Mailing.find(mailing)
    unless filtered
      tag = '[LCYC] '
    else
      tag = ''
    end
    @content = mailing.body
    filenames = mailing.attachments.map { |a| a.pdf.url(:original, false)}
    @url = "#{host}unsubscribe/#{person.email_hash}"
    filenames.each do |f|
      attachments[File.basename(f)] = File.read("#{Rails.root}/public/#{f}")
    end
    mail(to: person.EmailAddress,
         from: 'LCYC Announcements <lcyc@members.lcyc.info>',
         reply_to: mailing.replyto,
         subject: tag + mailing.subject)
  end

  def binnacle(email, filenames, binnacle_name, body)
    @content = body
    filenames.each do |f|
      attachments[File.basename(f)] = File.read("#{Rails.root}/public/#{f}")
    end
    mail(:to => email, :subject => "LCYC #{binnacle_name}")
  end

  def send_bills(mailing_id, email, mailingname, streetaddress, city, state, zip, status, mooring, drysail, dues, mooring_fees, drysail_fee, initiation)
    mailing = Mailing.find(mailing_id)
    filenames = mailing.attachments.map { |a| a.pdf.url(:original, false)}
    filenames.each do |f|
      attachments[File.basename(f)] = File.read("#{Rails.root}/public/#{f}")
    end
    @mailingname = mailingname
    @streetaddress = streetaddress
    @city = city
    @state = state
    @zip = zip
    @email = email
    @status = status.sub(/2016/,"")
    @mooring = mooring
    @drysail = drysail
    @dues = number_to_currency(dues).rjust(10)
    @mooring_fees = number_to_currency(mooring_fees).rjust(10)
    @drysail_fee = number_to_currency(drysail_fee).rjust(10)
    @initiation = number_to_currency(initiation).rjust(10)
    @total = number_to_currency(dues + mooring_fees + drysail_fee + initiation).rjust(10)
    mail(to: email,
         from: 'LCYC Announcements <lcyc@members.lcyc.info>',
         reply_to: mailing.replyto,
         subject: '[LCYC] ' + 'Annual Dues') do |format|
      format.html { render layout: 'bills'}
    end
  end

  def dbbackup(backup)
    attachments["sqldump.sql.gz"] = File.read(backup)
    mail(to: 'lcycadmin@gmail.com', subject: 'Database backup')
  end

end
