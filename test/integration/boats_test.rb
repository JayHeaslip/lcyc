require "test_helper"

class BoatsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:one)
    login_as(admin, "aqswde12$$")
    @membership = memberships(:member1)
    @boat = boats(:boat1)
    @membership6 = memberships(:member6)
    @boat4 = boats(:boat4)
  end

  test "get_index" do
    get boats_url
    assert_response :success
  end

  test "show" do
    get boat_url(@boat)
    assert_response :success
  end

  test "destroy boat" do
    @request.env["HTTP_REFERER"] = "http://test.com/membership/#{@membership.id}"
    get membership_url(@membership), headers: { HTTP_REFERER: memberships_url }
    delete membership_boat_url(@membership, @boat), headers: { HTTP_REFERER: membership_url(@membership) }
    assert_redirected_to membership_url(@membership)
  end

  test "destroy boat, last membership" do
    get membership_url(@membership), headers: { HTTP_REFERER: memberships_url }
    delete membership_boat_url(memberships(:member5), boats(:boat3)), headers: { HTTP_REFERER: membership_url(memberships(:member5)) }
    assert_redirected_to membership_url(memberships(:member5))
  end

  test "edit" do
    get edit_boat_url(@boat)
    assert_response :success
  end

  test "update" do
    patch boat_url(@boat), params: { boat: { Name: "new name" } }
    assert_equal "Successfully updated boat.", flash[:notice]
    assert_redirected_to boat_url(@boat)
  end

  test "member update" do
    login_as(users(:three), "passwor3")
    @boat = boats(:boat3)
    patch boat_url(@boat), params: { boat: { Name: "new name" } }
    assert_equal "Successfully updated boat.", flash[:notice]
    assert_redirected_to boat_url(@boat)
  end

  test "bad update" do
    patch boat_url(@boat), params: { boat: { Name: "", Mfg_Size: "" } }
    assert_response :unprocessable_entity
  end

  test "associate" do
    get associate_boat_url(@boat)
    assert_response :success
  end

  test "save association" do
    patch save_association_boat_url(@boat), params: { boat: { memberships: memberships(:member2).id } }
    assert_redirected_to boat_url(@boat)
  end

  test "destroy boat with more than one membership" do
    @request.env["HTTP_REFERER"] = "http://test.com/membership/#{@membership6.id}"
    get membership_url(@membership6), headers: { HTTP_REFERER: memberships_url }
    delete membership_boat_url(@membership6, @boat4), headers: { HTTP_REFERER: membership_url(@membership6) }
    assert_redirected_to membership_url(@membership6)
  end
end
