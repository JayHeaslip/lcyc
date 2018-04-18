require 'test_helper'

class MailRobotTest < ActionMailer::TestCase

  test "dbbackup" do
    email = MailRobot.dbbackup("#{Rails.root}/test/fixtures/files/dbbackup.sql")

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['lcyc@members.lcyc.info'], email.from
    assert_equal ['lcycadmin@gmail.com'], email.to
    assert_equal 'Database backup', email.subject
    assert_equal email.attachments.size, 1
    assert_equal email.attachments[0].filename, 'sqldump.sql.gz'

  end

  test "mailing" do
    @person = people(:bob)
    @mailing = mailings(:one)
    
    email = MailRobot.mailing(@person, @mailing.id, 'www.example.com')

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['lcyc@members.lcyc.info'], email.from
    assert_equal [@person.EmailAddress], email.to
    assert_equal "[LCYC] #{@mailing.subject}", email.subject

  end

end
