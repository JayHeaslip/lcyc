require 'test_helper'

class BoatsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @membership = memberships(:member1)
    @boat = boats(:boat1)
  end

  test "get_index" do
    get boats_url
    assert_response :success
  end

  test "show" do
    get boat_url(@boat)
    assert_response :success
  end

  test "destroy no membership" do
    get boats_url
    delete boat_url(@boat)
    assert_redirected_to boats_url
  end

  test "destroy membership" do
    get membership_url(@membership)
    delete membership_boat_url(@membership, @boat)
    assert_redirected_to membership_url(@membership)
  end

  test "edit" do
    get edit_boat_url(@boat)
    assert_response :success
  end
  
  test "update" do
    patch boat_url(@boat), params: {boat: {Name: 'new name'}}
    assert_equal "Successfully updated boat.", flash[:notice]
    assert_redirected_to boat_url(@boat)
  end
  
  test "member update" do
    login_as(users(:three), 'passwor3')
    @boat = boats(:boat3)
    patch boat_url(@boat), params: {boat: {Name: 'new name'}}
    assert_equal "Successfully updated boat.", flash[:notice]
    assert_redirected_to boat_url(@boat)
  end
  
  test "member authorize check" do
    logout
    login_as(users(:three), 'passwor3')
    @boat = boats(:boat1)
    patch boat_url(@boat), params: {boat: {Name: 'new name'}}
    assert_equal "You are not authorized to view the page you requested.", flash[:error]
    assert_redirected_to root_path
  end
  
  test "bad update" do
    patch boat_url(@boat), params: {boat: {Name: '', Mfg_Size: ''}}
    assert_response :unprocessable_entity
  end
  
  test "associate" do
    get associate_boat_url(@boat)
    assert_response :success
  end
  
  test "save association" do
    post save_association_boat_url(@boat), params: {boat: {memberships: memberships(:member2).id}}
    assert_redirected_to boat_url(@boat)
  end
  
end  
