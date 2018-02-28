require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest

  setup do
    admin = users(:one)
    login_as(admin, 'passwor1')
    @user = users(:two)
    @role = roles(:member)
    @right = rights(:user_destroy)
  end

  test "get_index" do
    get "/roles"
    assert_response :success
    assert_select "h2", "Roles"
  end

  test "show_role" do
    get "/roles/#{@role.id}"
    assert_response :success
    assert_select "h2", "Rights for #{@role.name}"
  end

  test "display edit form" do
    get "/roles/#{@role.id}/edit"
    assert_response :success
    assert_select "h2", "Rights Editor for #{@role.name}"
  end

  test "update role" do
    patch "/roles/#{@role.id}", params: {right_ids: [@right.id] }
    assert_redirected_to roles_url
    assert_equal flash[:notice], "#{@role.name} role was successfully updated."
  end

  test "delete role" do
    delete "/roles/#{@role.id}"
    assert_redirected_to roles_url
    assert_equal flash[:notice], "Deleted #{@role.name} role."
  end

end  
