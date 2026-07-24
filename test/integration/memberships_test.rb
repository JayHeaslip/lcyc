require "test_helper"

class MembershipsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    login_as(@admin, "aqswde12$$")
    @membership = memberships(:member1)
    @membership2 = memberships(:member2)
    @membership3 = memberships(:member3)
    @membership10 = memberships(:member10)
    @boat = boats(:boat1)
    @boat2 = boats(:boat2)
  end

  test "get admin" do
    get root_url
    assert_response :success
  end

  test "get index" do
    get memberships_url
    #save_and_open_page
    assert_response :success
    assert_select "p", "Total : 13"
  end

  test "show membership" do
    get membership_url(@membership3), headers: { HTTP_REFERER: memberships_url }
    assert_response :success
    assert_select "tr td", "Mailing Name:"
    assert_select "tr td+td", @membership3.MailingName
  end

  test "new" do
    get new_membership_url
    assert_response :success
    assert_select "h2", "New membership"
  end

  test "create membership" do
    assert_difference("Membership.count", 1) do
      post memberships_url, params: {
        membership: {
          LastName: "Doe_unique",
          MailingName: "Doe",
          StreetAddress: "123 Oak St",
          City: "Burlington",
          State: "VT",
          Zip: "05401",
          MemberSince: "2018",
          Status: "Active",
          active_date: "01-01-2018",
          people_attributes: [ { FirstName: "John", LastName: "Doe", Committee1: "Boats", MemberType: "Member" } ]
        }
      }
    end

    m = Membership.find_by(LastName: "Doe_unique")
    assert_redirected_to wl_membership_url(m)
    assert_equal "Membership was successfully created.", flash[:success]
  end

  test "create bad membership" do
    assert_no_difference("Membership.count") do
      post memberships_url, params: {
        membership: {
          LastName: "Doe",
          MailingName: "Doe",
          StreetAddress: "123 Oak St",
          City: "Burlington",
          State: "VT",
          Zip: "05401",
          MemberSince: "2018",
          Status: "Active",
          people_attributes: [ { FirstName: "John", LastName: "Doe", Committee1: "Boats", MemberType: "Partner" } ]
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "h2", "New membership"
  end

  test "create with rejected boat" do
    assert_difference("Membership.count", 1) do
      post memberships_url, params: {
        membership: {
          LastName: "Doe_unique",
          MailingName: "Doe",
          StreetAddress: "123 Oak St",
          City: "Burlington",
          State: "VT",
          Zip: "05401",
          MemberSince: "2018",
          Status: "Active",
          active_date: "01-01-2018",
          people_attributes: [ { FirstName: "John", LastName: "Doe", Committee1: "Boats", MemberType: "Member" } ],
          boat_attributes: [ { Name: "Testing", Mfg_Size: "", Type: "Sail" } ]
        }
      }
    end

    m = Membership.find_by(LastName: "Doe_unique")
    assert_redirected_to wl_membership_url(m)
    assert_equal "Membership was successfully created.", flash[:success]
  end

  test "display edit form" do
    get edit_membership_url(@membership)
    assert_response :success
    assert_select "h2", "Edit membership"
  end

  test "update membership" do
    patch membership_url(@membership), params: {
      membership: {
        LastName: "Bob",
        StreetAddress: "123 Main St",
        City: "Burlington",
        State: "VT",
        Zip: "05401",
        MemberSince: "1974",
        Status: "Active",
        active_date: "01-01-1974",
        people_attributes: [ { FirstName: "Jill", LastName: "Doe", Committee1: "Dock", MemberType: "Partner" } ]
      }
    }

    assert_redirected_to membership_url(@membership)
    assert_equal "Membership was successfully updated.", flash[:success]
    assert_equal "Bob", @membership.reload.LastName
  end

  test "bad membership update" do
    patch membership_url(@membership), params: {
      membership: {
        LastName: "Bob",
        StreetAddress: "123 Main St",
        City: "Burlington",
        State: "",
        Zip: "05401",
        MemberSince: "1974",
        Status: "Active"
      }
    }

    assert_response :unprocessable_entity
  end

  test "update membership from active to senior" do
    paid_membership = memberships(:paid)
    patch membership_url(paid_membership), params: {
      membership: {
        LastName: "Bob",
        StreetAddress: "123 Main St",
        City: "Burlington",
        State: "VT",
        Zip: "05401",
        MemberSince: "1974",
        Status: "Senior",
        people_attributes: [ { FirstName: "Jill", LastName: "Doe", Committee1: "Dock", MemberType: "Partner" } ]
      }
    }

    assert_redirected_to membership_url(paid_membership)
    assert_equal "Mooring removed due to membership category update.", flash[:alert]
    assert_equal "Membership was successfully updated.", flash[:success]
  end

  test "wait list add" do
    post wladd_membership_url(@membership)
    assert_redirected_to membership_url(@membership)
  end

  test "remove last membership from boat" do
    delete rmboat_membership_boat_url(@membership, @boat2), headers: { HTTP_REFERER: root_url }
    assert_equal "#{@membership.LastName} removed from boat, boat deleted.", flash[:notice]
    assert_redirected_to root_url
  end

  test "remove a moored boat with multiple owners from membership that owns the mooring" do
    membership = memberships(:member3)
    boat = boats(:boat4)

    delete rmboat_membership_boat_url(membership, boat), headers: { HTTP_REFERER: root_url }
    assert_equal "#{membership.LastName} removed from boat", flash[:notice]
    assert_redirected_to root_url
  end

  test "delete membership" do
    assert_difference("Membership.count", -1) do
      delete membership_url(@membership)
    end
    assert_redirected_to memberships_url
    assert_equal "Membership was successfully deleted.", flash[:success]
  end

  test "associate a boat form" do
    get associate_membership_url(@membership)
    assert_response :success
    assert_select "label", "Boats:"
  end

  test "save boat association" do
    boat3 = boats(:boat3)
    patch save_association_membership_url(@membership), params: { membership: { boats: boat3.id } }
    assert_redirected_to membership_url(@membership)
    assert_equal "Saved association.", flash[:notice]
  end

  test "show label form" do
    get labels_memberships_url
    assert_response :success
    assert_select "h2", "Generate Labels (Avery 5160)"
  end

  test "generate all labels" do
    post download_labels_memberships_url, params: { labels: "All" }
    assert_response :success
  end

  test "generate no email labels" do
    post download_labels_memberships_url, params: { labels: "No Email" }
    assert_response :success
  end

  test "generate workday labels" do
    post download_labels_memberships_url, params: { labels: "Workday" }
    assert_response :success
  end

  test "show spreadsheet form" do
    get spreadsheets_memberships_url
    assert_response :success
    assert_select "label", "Type:"
  end

  test "generate member spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Member Card" }
    assert_response :success
  end

  test "generate fleet spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Log Fleet" }
    assert_response :success
  end

  test "generate billing spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Billing" }
    assert_response :success
  end

  test "generate log members spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Log Members" }
    assert_response :success
  end

  test "generate log xref spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Log Partner Xref" }
    assert_response :success
  end

  test "generate resigned spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Resigned" }
    assert_response :success
  end

  test "generate evite spreadsheet" do
    post download_spreadsheet_memberships_url, params: { spreadsheet: "Evite" }
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

  test "display wait list add form" do
    get wl_membership_url(@membership3)
    assert_response :success
  end

  test "inactive returning to active wl date" do
    inactive = memberships(:inactive)
    patch membership_url(inactive), params: { membership: { Status: "Active" } }
    assert_redirected_to membership_url(inactive)
    assert_equal "For members returning to Active status from Inactive status, if adding to the waitlist, the waitlist date should be the day payment is received for the return to Active.", flash[:alert]
    assert_equal "Membership was successfully updated.", flash[:success]
  end

  test "delete membership with one boat" do
    assert_difference("Membership.count", -1) do
      delete membership_url(@membership3)
    end
    assert_equal "Membership was successfully deleted.", flash[:success]
    assert_redirected_to memberships_path
  end

  test "delete membership with more than one boat" do
    assert_difference("Membership.count", -1) do
      delete membership_url(@membership10)
    end
    assert_equal "Membership was successfully deleted.", flash[:success]
    assert_redirected_to memberships_path
  end
end
