#needed for number_to_currency
include ActionView::Helpers::NumberHelper

class MailRobot < ApplicationMailer
  
  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token
    mail(to: @user.email, subject: 'Confirm LCYC registration')
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token
    
    mail to: @user.email, subject: "LCYC Password Reset Instructions"
  end
  
  def mailing(url_options, person, mailing, host, filtered = nil)
    ActiveStorage::Current.url_options = url_options    
    unless filtered
      tag = '[LCYC] '
    else
      tag = ''
    end
    @url = "#{host}unsubscribe/#{person.email_hash}"
    @content = mailing.content
    mail(to: person.EmailAddress,
         from: 'LCYC Announcements <lcyc@members.lcyc.info>',
         reply_to: mailing.replyto,
         subject: tag + mailing.subject)
  end

  def dbbackup(backup)
    attachments["sqldump.sql.gz"] = File.read(backup)
    mail(to: 'lcycadmin@gmail.com', subject: 'Database backup')
  end

end
