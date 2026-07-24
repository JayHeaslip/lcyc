# test/jobs/send_bulk_loginfo_job_test.rb
require "test_helper"

class SendBulkLoginfoJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    @membership_1 = memberships(:member1) # Fixture or Factory record
    @membership_2 = memberships(:member2)
    @membership_ids = [@membership_1.id, @membership_2.id]
    @url_options = { host: "example.com" }

    # Mock Mailer response
    @mock_mail = Minitest::Mock.new
    @mock_mail.expect :encoded, "Subject: Test\n\nHello", []
    @mock_mail.expect :from, ["sender@example.com"], []
    @mock_mail.expect :destinations, ["recipient@example.com"], []

    # Mock SMTP connection
    @mock_smtp_conn = Minitest::Mock.new
  end

  test "sends emails for the current batch using SMTP" do
    sent_messages = []

    mock_smtp_conn = Object.new
    mock_smtp_conn.define_singleton_method(:send_message) do |msg, sender, recipients|
      sent_messages << { message: msg, sender: sender, recipients: recipients }
      true
    end

    dummy_mail = Struct.new(:encoded, :from, :destinations).new(
      "Subject: Log Info\n\nBody content",
      ["sender@example.com"],
      ["recipient@example.com"]
    )

    stub_smtp(mock_smtp_conn) do
      LogInfoMailer.stub :mailing, dummy_mail do
        SendBulkLoginfoJob.perform_now(@membership_ids.dup, @url_options, 2)
      end
    end

    assert_equal 2, sent_messages.size
    # Change ["sender@example.com"] to "sender@example.com"
    assert_equal "sender@example.com", sent_messages.first[:sender]
    assert_equal ["recipient@example.com"], sent_messages.first[:recipients]
  end

  test "re-queues remaining IDs when batch size is smaller than total IDs" do
    # Set batch size = 1, so 1 ID is processed and 1 ID remains
    @mock_smtp_conn.expect :send_message, true, [String, "sender@example.com", ["recipient@example.com"]]

    stub_smtp(@mock_smtp_conn) do
      LogInfoMailer.stub :mailing, @mock_mail do

        assert_enqueued_with(
          job: SendBulkLoginfoJob,
          args: [[@membership_2.id], @url_options, 1],
          queue: "mailers"
        ) do
          SendBulkLoginfoJob.perform_now(@membership_ids.dup, @url_options, 1)
        end

      end
    end

    assert @mock_smtp_conn.verify
  end

  test "rescues and logs individual email delivery failures without interrupting the batch" do
    call_count = 0
    
    mock_smtp_conn = Object.new
    mock_smtp_conn.define_singleton_method(:send_message) do |*args|
      call_count += 1
      raise "SMTP Timeout" if call_count == 1
      true
    end
    
    # Lightweight dummy mail object using Struct
    dummy_mail = Struct.new(:encoded, :from, :destinations).new(
      "Subject: Test\n\nHello",
      ["sender@example.com"],
      ["recipient@example.com"]
    )
    
    stub_smtp(mock_smtp_conn) do
      LogInfoMailer.stub :mailing, dummy_mail do
        assert_nothing_raised do
          SendBulkLoginfoJob.perform_now(@membership_ids.dup, @url_options, 2)
        end
      end
    end

    assert_equal 2, call_count
  end

  private

  # Helper to stub Net::SMTP connection lifecycle
  def stub_smtp(mock_conn, &block)
    mock_smtp_instance = Minitest::Mock.new
    
    # Expect enable_starttls_auto if configured in smtp_settings
    if Rails.application.config.action_mailer.smtp_settings[:enable_starttls_auto]
      mock_smtp_instance.expect :enable_starttls_auto, true
    end
    
    # Stub start method to yield the mock connection block
    mock_smtp_instance.expect(:start, nil) do |*_args, &start_block|
      start_block.call(mock_conn)
    end
    
    Net::SMTP.stub :new, mock_smtp_instance do
      yield
    end
  end
end
