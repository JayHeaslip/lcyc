require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @boat = boats(:boat1)
  end

  test "get_index" do
    get memberships_url
    assert_response :success
    assert_select "fieldset + p", "Total : 7"
  end

  test "show_membership" do
    get membership_url(@membership)
    assert_response :success
    assert_select "tr td", "Mailing Name:"
    assert_select "tr td+td", @membership.MailingName
  end

  test "display edit form" do
    get edit_membership_url(@membership)
    assert_response :success
    assert_select "h2", "Edit membership"
  end

  test "update membership" do
    patch membership_url(@membership),
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

  test "delete membership" do
    delete membership_url(@membership)
    assert_redirected_to memberships_url
    assert_equal flash[:notice], "Membership was successfully deleted."
  end

  test "associate a boat form" do
    get associate_membership_url(@membership)
    assert_response :success
    assert_select "label", "Boats:"
  end

  test "save boat association" do
    post save_association_membership_url(@membership),
         params: {membership: {boats: @boat.id}, id: @membership.id}
    assert_redirected_to membership_url(@membership.id)
    assert_equal flash[:notice], "Saved association."
  end

  test "show label form" do
    get labels_memberships_url
    assert_response :success
    assert_select "h2", "Generate Labels (Avery 5160)"
  end

  test "generate labels" do
    post download_labels_memberships_url, params: {labels: 'All'}
    assert_response :success
  end
  
  test "show spreadsheet form" do
    get spreadsheets_memberships_url
    assert_response :success
    assert_select "label", "Type:"
  end

  test "generate spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Member Card'}
    assert_response :success
  end
  
end  
