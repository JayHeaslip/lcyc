# test/jobs/send_bulk_announcement_job_test.rb
require "test_helper"

class SendBulkAnnouncementJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    @mailing = mailings(:one) rescue Mailing.create!(subject: "Test Bulk Mail")
    @person1 = people(:bob)
    @person2 = people(:jim)
    
    @person_ids = [@person1.id, @person2.id]
    @url_options = { host: "example.com", protocol: "https" }

    # Setup dummy SMTP config in case test environment lacks it
    Rails.application.config.action_mailer.smtp_settings = {
      address: "smtp.example.com",
      port: 587,
      domain: "example.com",
      user_name: "user",
      password: "password",
      authentication: :plain,
      enable_starttls_auto: true
    }
  end

  # ==========================================
  # 1. Batch Scheduling Tests
  # ==========================================

  test "processes current batch and enqueues next batch with delay when IDs remain" do
    large_list = (1..50).to_a

    # Stub SMTP call so no real network connections happen
    stub_smtp_connection do
      assert_enqueued_with(
        job: SendBulkAnnouncementJob,
        args: [@mailing.id, (21..50).to_a, @url_options, 20],
        at: 30.seconds.from_now
      ) do
        SendBulkAnnouncementJob.perform_now(@mailing.id, large_list, @url_options, 20)
      end
    end
  end

  test "does not enqueue further jobs when recipient list is exhausted" do
    stub_smtp_connection do
      assert_no_enqueued_jobs(only: SendBulkAnnouncementJob) do
        SendBulkAnnouncementJob.perform_now(@mailing.id, [@person1.id], @url_options, 20)
      end
    end
  end

  # ==========================================
  # 2. SMTP & Mail Delivery Tests
  # ==========================================

  test "starts SMTP session and sends messages for found people" do
    # Dummy Mail Message mock
    mock_mail = Struct.new(:encoded, :from, :destinations).new(
      "Subject: Test\n\nHello",
      ["sender@example.com"],
      ["bob@example.com"]
    )

    # Mock smtp connection object yield block parameter
    mock_conn = Minitest::Mock.new
    mock_conn.expect :send_message, nil, [mock_mail.encoded, "sender@example.com", ["bob@example.com"]]

    stub_smtp_connection(connection_mock: mock_conn) do
      AnnouncementMailer.stub :mailing, mock_mail do
        SendBulkAnnouncementJob.perform_now(@mailing.id, [@person1.id], @url_options, 20)
      end
    end

    assert mock_conn.verify
  end

  test "skips non-existent person IDs gracefully" do
    non_existent_id = 999_999
    ids_with_missing = [non_existent_id, @person1.id]

    mock_mail = Struct.new(:encoded, :from, :destinations).new(
      "Subject: Test",
      ["sender@example.com"],
      ["bob@example.com"]
    )

    # Expect send_message to be called ONLY ONCE for @person1.id
    mock_conn = Minitest::Mock.new
    mock_conn.expect :send_message, nil, [mock_mail.encoded, "sender@example.com", ["bob@example.com"]]

    stub_smtp_connection(connection_mock: mock_conn) do
      AnnouncementMailer.stub :mailing, mock_mail do
        assert_nothing_raised do
          SendBulkAnnouncementJob.perform_now(@mailing.id, ids_with_missing, @url_options, 20)
        end
      end
    end

    assert mock_conn.verify
  end

  test "rescues and logs errors raised during individual email sending" do
    mock_conn = Object.new
    def mock_conn.send_message(*_args)
      raise StandardError, "SMTP Connection Drop"
    end

    # Capture rails logger output to ensure error is logged
    logger_output = StringIO.new
    Rails.logger.stub :error, ->(msg) { logger_output.puts(msg) } do
      stub_smtp_connection(connection_mock: mock_conn) do
        assert_nothing_raised do
          SendBulkAnnouncementJob.perform_now(@mailing.id, [@person1.id], @url_options, 20)
        end
      end
    end

    assert_includes logger_output.string, "Failed to send to ID #{@person1.id}: SMTP Connection Drop"
  end

  private

  # Helper to stub Net::SMTP so it yields a mock connection block
  def stub_smtp_connection(connection_mock: nil)
    connection_mock ||= Minitest::Mock.new

    mock_smtp_instance = Object.new
    mock_smtp_instance.define_singleton_method(:enable_starttls_auto) { true }
    mock_smtp_instance.define_singleton_method(:start) do |*_args, &block|
      block.call(connection_mock) if block
    end

    Net::SMTP.stub :new, mock_smtp_instance do
      yield
    end
  end
end
