require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "get_committee" do
    get committee_people_url
    assert_response :success
    assert_select "h2", "Committee Members"
  end

  test "unsubscribe bad hash" do
    get unsubscribe_url('1234')
    assert_redirected_to root_url
    assert_equal flash[:notice], "Email address not found."
  end

  test "unsubscribe" do
    get unsubscribe_url('2345')
    assert_redirected_to root_url
    assert_equal flash[:notice], "You have unsubscribed."
  end

  test "delete" do
    login_as(users(:three), 'passwor3')
    @membership = memberships(:member2)
    @person = people(:jill)
    delete membership_person_url(@membership, @person)
    assert_redirected_to membership_url(@membership)
    assert_equal flash[:notice], "Person was successfully deleted."
  end

  test "delete invalid membership" do
    login_as(users(:three), 'passwor3')
    @membership = memberships(:member1)
    @person = people(:jill)
    delete membership_person_url(@membership, @person)
    assert_redirected_to root_url
    assert_equal flash[:error], "You are not authorized to view the page you requested."
  end

  test "delete by admin" do
    @membership = memberships(:member2)
    @person = people(:jill)
    delete membership_person_url(@membership, @person)
    assert_redirected_to membership_url(@membership)
    assert_equal flash[:notice], "Person was successfully deleted."
  end

end  
