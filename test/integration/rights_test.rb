require "test_helper"

class RightsIntegrationTest < ActionDispatch::IntegrationTest
  test "synchronize" do
    Right.synchronize_with_controllers
  end

  test "synchronize removing right" do
    r = Right.new(name: "Users#bogus", controller: "Users", action: "bogus")
    r.save
    Right.synchronize_with_controllers
  end
end
