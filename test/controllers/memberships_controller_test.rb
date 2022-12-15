require "test_helper"

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership = memberships(:member2)
    @user = users(:three)
    login_as @user, 'passwor3'
  end
  
  test "should update if initiation installment amount is not blank" do
    attrs = @membership.attributes
    params = {membership: attrs}
    params[:membership][:initiation_installments_attributes] = {"0": {amount: 1000, year: 2022}}
    put membership_path(@membership), params: params
    assert_response :unprocessable_entity
  end
  
  test "should not update if initiation installment amount is blank" do
    attrs = @membership.attributes
    params = {membership: attrs}
    params[:membership][:initiation_installments_attributes] = {"0": {amount: nil, year: 2022}}
    put membership_path(@membership), params: params
    assert_response :unprocessable_entity
  end
  
  test "should update if boat name is not blank" do
    attrs = @membership.attributes
    params = {membership: attrs}
    params[:membership][:boats_attributes] = {"0": {"Mfg_Size": nil, "Name": "Hello"}}
    put membership_path(@membership), params: params
    assert_response :unprocessable_entity
  end
  
  test "should update if mfg/size is not blank" do
    attrs = @membership.attributes
    params = {membership: attrs}
    params[:membership][:boats_attributes] = {"0": {"Mfg_Size": "SeaRay", "Name": nil}}
    put membership_path(@membership), params: params
    assert_response :unprocessable_entity
  end
  
end
