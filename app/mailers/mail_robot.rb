# needed for number_to_currency
class MailRobot < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token
    mail(to: @user.email, subject: "Confirm LCYC registration")
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token

    mail to: @user.email, subject: "LCYC Password Reset Instructions"
  end

  def mailing(url_options, person, mailing, host, filtered = nil)
    ActiveStorage::Current.url_options = url_options
    tag = "[LCYC] "
    @url = "#{host}unsubscribe/#{person.email_hash}"
    @content = mailing.content
    mailing.pdfs.each do |p|
      attachments[p.filename.to_s] = p.download
    end
    mail(to: person.EmailAddress,
      from: "LCYC Announcements <lcyc@members.lcyc.info>",
      reply_to: mailing.replyto,
      subject: tag + mailing.subject)
  end

  def loginfo(url_options, to, cc, membership_chair, membership, boat, member, partner, children)
    ActiveStorage::Current.url_options = url_options
    @membership_chair = membership_chair
    @membership = membership
    @boat = boat
    @member = member
    @partner = partner
    @children = children
    mail(to: to,
      cc: cc,
      from: "LCYC Announcements <lcyc@members.lcyc.info>",
      reply_to: "lcycsecretary@gmail.com",
      subject: "[LCYC] Log info verification")
  end

  def dbbackup(backup)
    attachments["sqldump.sql.gz"] = File.read(backup)
    mail(to: "lcycadmin@gmail.com", subject: "Database backup")
  end
end
