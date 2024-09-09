require "test_helper"

class LogInfoEmailTest < ActiveSupport::TestCase

  test "should create a log info email" do
    @email = LogInfoEmail.new(subject: "testing", body: "test body")
    assert @email.save, true
  end
end

