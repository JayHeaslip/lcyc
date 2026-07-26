# test/controllers/log_info_emails_controller_test.rb
require "test_helper"

class LogInfoEmailsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @confirmed_user = users(:non_member)

    @communications_user = users(:communications)

    # Ensure LogInfoEmail with ID 1 exists
    @log_info_email = LogInfoEmail.find_or_create_by!(id: 1) do |email|
      email.subject = "Initial Subject"
      email.body = "Initial Body"
    end

    # Ensure fallback membership #407 exists
    @fallback_membership = memberships(:member11)

    @membership = memberships(:commem)
  end

  # ==========================================
  # 1. Edit Action
  # ==========================================

  test "should display edit form when logged in as member" do
    login_as @communications_user,'communications'
    get edit_log_info_email_path
    assert_response :success
  end

  test "should display edit form and fallback to membership 407 when user is not a member" do
    # User whose email does not exist in Person table
    non_member_user = users(:non_member)

    login_as non_member_user,'nonmem'
    get edit_log_info_email_path
    assert_response :success
  end

  # ==========================================
  # 2. Update Action - Test Mode
  # ==========================================

  test "send log info emails test mode enqueues job for current user membership" do
    login_as @communications_user, 'communications'

    assert_enqueued_with(job: SendBulkLoginfoJob) do
      patch log_info_email_path(1), params: {
        log_info_email: {
          subject: "[LCYC] Test Subject",
          body: "Please review your log info.",
          test: "true"
        }
      }
    end

    # Check the actual enqueued job arguments directly from the queue helper
    enqueued_job = enqueued_jobs.last
    assert_equal [@membership.id], enqueued_job[:args].first

    assert_redirected_to root_url
    assert_equal "Log info emails sent.", flash[:notice]
    assert_equal "[LCYC] Test Subject", @log_info_email.reload.subject
  end

  test "send log info emails test mode falls back to membership 407 when user has no person record" do
    non_member_user = users(:non_member)

    login_as non_member_user,'nonmem'

    assert_enqueued_with(job: SendBulkLoginfoJob) do
      patch log_info_email_path(1), params: {
        log_info_email: {
          subject: "[LCYC] Test Subject",
          body: "Please review your log info.",
          test: "true"
        }
      }
    end

    enqueued_job = enqueued_jobs.last
    assert_equal [407], enqueued_job[:args].first

    assert_redirected_to root_url
    assert_equal "Log info emails sent.", flash[:notice]
  end

  # ==========================================
  # 3. Update Action - Production/All Members Mode
  # ==========================================

  test "send log info emails enqueues job for all active member ids" do
    login_as @communications_user,'communications'

    expected_ids = Membership.members.ids

    assert_enqueued_with(job: SendBulkLoginfoJob) do
      patch log_info_email_path(1), params: {
        log_info_email: {
          subject: "[LCYC] Log info verification",
          body: "Full bulk send.",
          test: "false"
        }
      }
    end

    enqueued_job = enqueued_jobs.last
    assert_equal expected_ids, enqueued_job[:args].first

    assert_redirected_to root_url
    assert_equal "Log info emails sent.", flash[:notice]
  end

  # ==========================================
  # 4. Failed Validation Handling
  # ==========================================

  test "renders edit with status 422 when log info email update fails" do
    login_as @communications_user,'communications'


    # Assuming LogInfoEmail validates presence of subject or body
    # Adjust invalid payload parameters according to your model validations
    patch log_info_email_path(1), params: {
      log_info_email: {
        subject: "",
        body: ""
      }
    }

    assert_response :unprocessable_entity
    assert_template :edit
  end
end
