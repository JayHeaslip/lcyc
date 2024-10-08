require "test_helper"

class RightsIntegrationTest < ActionDispatch::IntegrationTest
  test "synchronize" do
    Right.synchronize_with_controllers
    r = Right.find_by(name: "MembershipsController.new")
    assert_equal "MembershipsController.new", r.name
  end

  test "synchronize removing right" do
    r = Right.new(name: "UsersController.bogus", controller: "users", action: "bogus")
    r.save
    Right.synchronize_with_controllers
    assert_nil Right.find_by(name: "UsersController.bogus")
  end
end
