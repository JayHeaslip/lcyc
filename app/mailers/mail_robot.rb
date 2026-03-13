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

  def dbbackup(backup)
    attachments["sqldump.sql.gz"] = File.read(backup)
    mail(to: "lcycadmin@gmail.com", subject: "Database backup")
  end
end
