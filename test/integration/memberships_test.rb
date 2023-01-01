require 'test_helper'

class MembershipsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @membership3 = memberships(:member3)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "get admin" do
    get root_url
    assert_response :success
  end
  
  test "get_index" do
    get memberships_url
    assert_response :success
    assert_select "p", "Total : 9"
  end

  test "show_membership" do
    get membership_url(@membership3)
    assert_response :success
    assert_select "tr td", "Mailing Name:"
    assert_select "tr td+td", @membership3.MailingName
  end

  test "new" do
    get new_membership_url
    assert_response :success
    assert_select "h2", "New membership"
  end

  test "create " do
    post memberships_url, params: {membership:
                                     {LastName: "Doe_unique",
                                      MailingName: "Doe",
                                      StreetAddress: "123 Oak St",
                                      City: "Burlington",
                                      State: "VT",
                                      Zip: '05401',
                                      MemberSince: '2018',
                                      Status: 'Active',
                                      people_attributes: [{FirstName: 'John', LastName: 'Doe',
                                             Committee1: 'Boats', MemberType: 'Member'}]}}

    @m = Membership.find_by_LastName('Doe_unique')
    assert_redirected_to wl_membership_url(@m)
    assert_equal flash[:success], 'Membership was successfully created.'
  end

  test "create bad " do
    post memberships_url, params: {membership:
                                     {LastName: "Doe",
                                      MailingName: "Doe",
                                      StreetAddress: "123 Oak St",
                                      City: "Burlington",
                                      State: "VT",
                                      Zip: '05401',
                                      MemberSince: '2018',
                                      Status: 'Active',
                                      people_attributes: [{FirstName: 'John', LastName: 'Doe',
                                             Committee1: 'Boats', MemberType: 'Partner'}]}}
                                   
    assert_response 422
    assert_select "h2", "New membership"
  end

  test "create with rejected boat " do
    post memberships_url, params: {membership:
                                     {LastName: "Doe_unique",
                                      MailingName: "Doe",
                                      StreetAddress: "123 Oak St",
                                      City: "Burlington",
                                      State: "VT",
                                      Zip: '05401',
                                      MemberSince: '2018',
                                      Status: 'Active',
                                      people_attributes: [{FirstName: 'John', LastName: 'Doe',
                                                           Committee1: 'Boats', MemberType: 'Member'}],
                                      boat_attributes: [{Name: 'Testing', Mfg_Size: '', Type: 'Sail'}]
                                       
                                     }
                                  }

    @m = Membership.find_by_LastName('Doe_unique')
    assert_redirected_to wl_membership_url(@m)
    assert_equal flash[:success], 'Membership was successfully created.'
  end
  
  test "display edit form" do
    get edit_membership_url(@membership)
    assert_response :success
    assert_select "h2", "Edit membership"
  end

  test "display member edit form" do
    logout
    login_as(users(:three), 'passwor3')
    get edit_membership_url(@membership2)
    assert_response :success
    assert_select "h2", "Edit membership"
  end

  ##test "display invalid member edit form" do
  ##  logout
  ##  login_as(users(:three), 'passwor3')
  ##  get edit_membership_url(@membership)
  ##  assert_redirected_to root_path
  ##  assert_equal flash[:error], "You are not authorized to view the page you requested."
  ##end

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
                       Status: 'Active',
                       people_attributes: [{FirstName: 'Jill', LastName: 'Doe',
                                             Committee1: 'Dock', MemberType: 'Partner'}]
                       
                     }
                  }
    assert_redirected_to membership_url(@membership.id)
    assert_equal flash[:success], "Membership was successfully updated."
  end

  test "bad membership" do
    patch membership_url(@membership),
          params: {membership:
                     {
                       LastName: 'Bob',
                       StreetAddress: '123 Main St',
                       City: 'Burlington',
                       State: '',
                       Zip: '05401',
                       MemberSince: '1974',
                       Status: 'Active'                       
                     }
                  }
    assert_response :unprocessable_entity
  end

  test "update membership from active to senior" do
    patch membership_url(memberships(:paid)),
          params: {membership:
                     {
                       LastName: 'Bob',
                       StreetAddress: '123 Main St',
                       City: 'Burlington',
                       State: 'VT',
                       Zip: '05401',
                       MemberSince: '1974',
                       Status: 'Senior',
                       people_attributes: [{FirstName: 'Jill', LastName: 'Doe',
                                             Committee1: 'Dock', MemberType: 'Partner'}]
                       
                     }
                  }
    assert_redirected_to membership_url(memberships(:paid))
    assert_equal flash[:alert], "Mooring removed due to membership category update."
    assert_equal flash[:success], "Membership was successfully updated."
  end

  test "wait list add" do
    post wladd_membership_url(@membership)
    assert_redirected_to membership_url(@membership)
  end
  
  test "remove last membership from boat" do
    delete rmboat_boat_membership_url(@boat2, @membership)
    assert_redirected_to boats_url
  end
  
  test "remove a moored boat with multiple owners from membership that owns the mooring" do
    delete rmboat_boat_membership_url(@boat, @membership)
    assert_redirected_to boat_url(@boat)
  end
  
  test "delete membership" do
    delete membership_url(@membership)
    assert_redirected_to memberships_url
    assert_equal flash[:success], "Membership was successfully deleted."
  end

  test "associate a boat form" do
    get associate_membership_url(@membership)
    assert_response :success
    assert_select "label", "Boats:"
  end

  test "save boat association" do
    @boat3 = boats(:boat3)
    post save_association_membership_url(@membership),
         params: {membership: {boats: @boat3.id}, id: @membership.id}
    assert_redirected_to membership_url(@membership.id)
    assert_equal flash[:notice], "Saved association."
  end

  test "show label form" do
    get labels_memberships_url
    assert_response :success
    assert_select "h2", "Generate Labels (Avery 5160)"
  end

  test "generate all labels" do
    post download_labels_memberships_url, params: {labels: 'All'}
    assert_response :success
  end
  
  test "generate no email labels" do
    post download_labels_memberships_url, params: {labels: 'No Email'}
    assert_response :success
  end
  
  test "generate workday labels" do
    post download_labels_memberships_url, params: {labels: 'Workday'}
    assert_response :success
  end
  
  test "show spreadsheet form" do
    get spreadsheets_memberships_url
    assert_response :success
    assert_select "label", "Type:"
  end

  test "generate member spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Member Card'}
    assert_response :success
  end
  
  test "generate fleet spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Log Fleet'}
    assert_response :success
  end
  
  test "generate billing spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Billing'}
    assert_response :success
  end
  
  test "generate log members spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Log Members'}
    assert_response :success
  end

  test "generate log xref spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Log Partner Xref'}
    assert_response :success
  end
  
  test "generate resigned spreadsheet" do
    post download_spreadsheet_memberships_url, params: {spreadsheet: 'Resigned'}
    assert_response :success
  end

  test "unassign a mooring" do
    post unassign_membership_url(@membership)
    assert_equal "Mooring #261007983 unassigned.", flash[:notice]
    assert_redirected_to moorings_path
  end
  
  test "unassign a drysail" do
    post unassign_drysail_membership_url(@membership)
    assert_equal "Dry sail spot #1 unassigned.", flash[:notice]
    assert_redirected_to drysails_path
  end
  
  test "generate an initiation report" do
    get initiation_report_memberships_url
    assert_select "h2", "Initiation installments due"
  end
  
end  
