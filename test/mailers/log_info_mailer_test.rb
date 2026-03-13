require "test_helper"

class LogInfoMailerTest < ActionMailer::TestCase
  test "loginfo" do
    @mailing = mailings(:loginfo)
    membership = memberships(:member1)

    email = LogInfoMailer.mailing(membership.id, ActiveStorage::Current.url_options)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "lcyc@members.lcyc.info" ], email.from
    assert_equal [ "bob@abc.com" ], email.to
    assert_nil email.cc
    assert_equal "[LCYC] Log info verification", email.subject
  end
end
