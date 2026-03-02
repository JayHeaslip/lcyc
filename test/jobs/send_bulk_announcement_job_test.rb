require "test_helper"

class SendBulkAnnouncementJobTest < ActiveJob::TestCase
  setup do
    @mailing = Mailing.create!(subject: "Test Bulk Mail")
    @person_ids = (1..50).to_a # Simulating 50 recipients
    @url_options = { host: "localhost:3000", protocol: "http" }
  end

  test "processes current batch and enqueues next batch with delay" do
    # 1. We expect Net::SMTP to start exactly once for this execution
    # We mock the start method to ensure no real emails are sent
    mock_smtp = Minitest::Mock.new
    mock_smtp.expect(:start, nil, [ String, String, String, Symbol ])

    # Verify the recursive scheduling
    assert_enqueued_with(
      job: SendBulkAnnouncementJob,
      args: [ @mailing.id, (21..50).to_a, @url_options, 20 ],
      at: 30.seconds.from_now
    ) do
      # Run the job for a batch of 20
      SendBulkAnnouncementJob.perform_now(@mailing.id, @person_ids, @url_options, 20)
    end
  end

  test "does not enqueue further jobs when list is exhausted" do
    small_list = [ 1, 2, 3 ]

    assert_no_enqueued_jobs(only: SendBulkAnnouncementJob) do
      SendBulkAnnouncementJob.perform_now(@mailing.id, small_list, @url_options, 20)
    end
  end
end
