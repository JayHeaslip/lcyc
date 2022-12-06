require 'test_helper'

class CommitteesControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "download_spreadsheet" do
    post download_spreadsheet_committee_url('Boats')
    assert_response :success
  end

  test "show_committee" do
    get select_committee_people_url
    assert_response :success
    assert_select "h2", "Committee Members"
  end

  test "unsubscribe bad hash" do
    logout
    get '/unsubscribe/1234'
    assert_redirected_to root_url
    assert_equal flash[:alert], "Email address not found."
  end

  test "unsubscribe" do
    logout
    get '/unsubscribe/2345'
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

  test "delete by admin" do
    @membership = memberships(:member2)
    @person = people(:jill)
    delete membership_person_url(@membership, @person)
    assert_redirected_to membership_url(@membership)
    assert_equal flash[:notice], "Person was successfully deleted."
  end

end  
