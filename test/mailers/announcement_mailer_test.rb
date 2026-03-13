require "test_helper"

class AnnounceEmailTest < ActionMailer::TestCase
  test "mailing" do
    @person = people(:bob)
    @mailing = mailings(:one)
    url_options = {}
    email = AnnouncementMailer.mailing(@person.id, @mailing.id, url_options, "www.example.com")

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "lcyc@members.lcyc.info" ], email.from
    assert_equal [ @person.EmailAddress ], email.to
    assert_equal "[LCYC] #{@mailing.subject}", email.subject
  end

  test "mailing with pdf" do
    @person = people(:bob)
    @mailing = mailings(:one)
    @mailing.pdfs.attach(io: File.open("/home/jay/rails/lcyc/test/fixtures/files/first.pdf"), filename: "first.pdf", content_type: "application/pdf")
    @mailing.save
    url_options = {}
    email = AnnouncementMailer.mailing(@person.id, @mailing.id, url_options, "www.example.com")

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "lcyc@members.lcyc.info" ], email.from
    assert_equal [ @person.EmailAddress ], email.to
    assert_equal "[LCYC] #{@mailing.subject}", email.subject
  end

  test "mailing with invalid file type" do
    @person = people(:bob)
    @mailing = mailings(:one)
    @mailing.pdfs.attach(io: File.open("/home/jay/rails/lcyc/test/fixtures/files/lcyc.jpg"), filename: "lcyc.jpg", content_type: "image/jpeg")
    assert_not @mailing.save
  end
end
