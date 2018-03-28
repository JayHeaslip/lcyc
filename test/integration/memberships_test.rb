require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
  end

  test "get_index" do
    get "/memberships"
    assert_response :success
    assert_select "fieldset + p", "Total : 3"
  end

  test "show_membership" do
    get "/memberships/#{@membership.id}"
    assert_response :success
    assert_select "tr td", "Mailing Name:"
    assert_select "tr td+td", @membership.MailingName
  end

  test "display edit form" do
    get "/memberships/#{@membership.id}/edit"
    assert_response :success
    assert_select "h2", "Edit membership"
  end

  test "update role" do
    patch "/memberships/#{@membership.id}",
          params: {membership:
                     {
                       LastName: 'Bob',
                       StreetAddress: '123 Main St',
                       City: 'Burlington',
                       State: 'VT',
                       Zip: '05401',
                       MemberSince: '1974',
                       Status: 'Active'                       
                     }
                  }
    assert_redirected_to membership_url(@membership.id)
    assert_equal flash[:notice], "Membership was successfully updated."
  end

  test "delete role" do
    delete "/memberships/#{@membership.id}"
    assert_redirected_to memberships_url
    assert_equal flash[:notice], "Membership was successfully deleted."
  end

end  
