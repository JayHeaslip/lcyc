require "test_helper"

class RightsIntegrationTest < ActionDispatch::IntegrationTest
  test "synchronize" do
    Right.synchronize_with_controllers
  end

  test "synchronize removing right" do
    r = Right.new(name: "UsersController.bogus", controller: "users", action: "bogus")
    r.save
    Right.synchronize_with_controllers
  end
end
