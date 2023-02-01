require "test_helper"

class DrysailsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "passwor1")
  end

  test "assign drysail spot" do
    get assign_drysail_url(drysails(:drysail1))
    assert_select "h2", "Assigning dry sail spot #1"
    assert_response :success
  end

  test "update drysail spot" do
    patch drysail_url(drysails(:drysail1)), params: {membership: ActiveRecord::FixtureSet.identify(:member2)}
    flash[:success] = "Assigned dry sail spot #1."
    assert_redirected_to drysails_url
  end

  test "list drysail spots" do
    get drysails_url
    assert_select "h2", "Dry Sailing Storage Assignment"
    assert_response :success
  end
end
