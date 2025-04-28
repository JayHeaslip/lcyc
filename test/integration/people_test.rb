require "test_helper"

class PeopleIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "passwor1")
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "unsubscribe bad hash" do
    logout
    get "/unsubscribe/1234"
    assert_redirected_to root_url
    assert_equal flash[:alert], "Email address not found."
  end

  test "unsubscribe get" do
    logout
    get "/unsubscribe/2345"
    assert_response :success
  end

  test "unsubscribe put" do
    logout
    put "/unsubscribe/2345"
    assert_redirected_to root_url
    assert_equal flash[:notice], "You have unsubscribed."
  end

  test "delete by membership" do
    login_as(users(:membership), "passwor1")
    @membership = memberships(:member2)
    @person = people(:jill)
    delete membership_person_url(@membership, @person)
    assert_redirected_to membership_url(@membership)
    assert_equal flash[:notice], "Person was successfully deleted."
  end

  test "delete by admin" do
    @membership = memberships(:member2)
    @person = people(:jill)
    delete membership_person_url(@membership, @person)
    assert_redirected_to membership_url(@membership)
    assert_equal flash[:notice], "Person was successfully deleted."
  end
end
