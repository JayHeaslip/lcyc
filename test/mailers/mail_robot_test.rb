require "test_helper"

class MailRobotTest < ActionMailer::TestCase
  test "dbbackup" do
    email = MailRobot.dbbackup("#{Rails.root}/test/fixtures/files/dbbackup.sql")

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "lcyc@members.lcyc.info" ], email.from
    assert_equal [ "lcycadmin@gmail.com" ], email.to
    assert_equal "Database backup", email.subject
    assert_equal email.attachments.size, 1
    assert_equal email.attachments[0].filename, "sqldump.sql.gz"
  end
end
