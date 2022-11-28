require "test_helper"

class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @user = User.new(firstname: 'bob', lastname: 'bob', email: "unique_email@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should have email" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "email should be unique" do
    @user.save!
    @invalid_user = User.new(email: @user.email)

    assert_not @invalid_user.valid?
  end

  test "email should be saved as lowercase" do
    email = "unique_email@example.com"

    @user = User.new(firstname: 'bob', lastname: 'bob', email: email.upcase, password: "password", password_confirmation: "password")
    @user.save!

    assert_equal email.downcase, @user.email
  end

  test "email should be valid" do
    invalid_emails = %w[foo foo@ foo@bar.]

    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?
    end
  end

  test "should respond to confirmed?" do
    assert_not @user.confirmed?

    @user.confirmed_at = Time.now

    assert @user.confirmed?
  end

  test "should respond to unconfirmed?" do
    assert @user.unconfirmed?

    @user.confirmed_at = Time.now

    assert_not @user.unconfirmed?
  end


  test "should send confirmation email" do
    @user.save!

    assert_emails 1 do
      @user.send_confirmation_email!
    end

    assert_equal @user.email, ActionMailer::Base.deliveries.last.to[0]
  end

  test "should respond to send_password_reset_email!" do
    @user.save!

    assert_emails 1 do
      @user.send_password_reset_email!
    end
  end

  test ".confirm! should return false if already confirmed" do
    @confirmed_user = User.new(email: "unique_email@example.com", password: "password", password_confirmation: "password", confirmed_at: Time.current)

    assert_not @confirmed_user.confirm!
  end


  test ".confirm! should set confirmed_at" do
    @unconfirmed_user = User.create!(firstname: 'jim', lastname: 'jim', email: "unique_email@example.com", password: "password", password_confirmation: "password")

    freeze_time do
      @unconfirmed_user.confirm!

      assert_equal Time.current, @unconfirmed_user.reload.confirmed_at
    end
  end

  test "should create active session" do
    @user.save!

    assert_difference("@user.active_sessions.count", 1) do
      @user.active_sessions.create!
    end
  end

  test "should destroy associated active session when destryoed" do
    @user.save!
    @user.active_sessions.create!

    assert_difference("@user.active_sessions.count", -1) do
      @user.destroy!
    end
  end
end
