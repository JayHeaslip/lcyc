# test/controllers/directory_controller_test.rb
require "test_helper"

class DirectoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership = memberships(:member1)
    @other_membership = memberships(:member2)

    @person = people(:bob)
    @partner = people(:sue)
    @other_person = people(:jim)

    # users for authorization tests
    @regular_user = users(:two)
    @other_user = users(:three)

    @admin_user = users(:one)
  end

  # --- 1. Index Action Tests ---

  test "should get index and list members and partners" do
    login_as(@regular_user, "passwor2")
    get directory_index_url
    assert_response :success
    assert_select "h2", "Membership Directory"
  end

  test "should filter members when search query is provided" do
    login_as(@regular_user, "passwor2")
    get directory_index_url(query: "Alice")
    assert_response :success
  end

  # --- 2. Show Action Tests ---

  test "should show person profile" do
    login_as(@regular_user, "passwor2")
    get directory_url(@person)
    assert_response :success
  end

  # --- 3. Authorization & Edit Action Tests ---

  test "should allow user to edit their own membership profile" do
    login_as(@regular_user, "passwor2")
    get edit_directory_url(@person)
    assert_response :success
  end

  test "should allow admin to edit any membership profile" do
    login_as(@admin_user, "aqswde12$$")

    get edit_directory_url(@person)
    assert_response :success
  end

  test "should deny unauthorized user from editing another profile" do
    login_as(@other_user, "passwor3")

    get edit_directory_url(@person)

    assert_redirected_to directory_index_path
    assert_equal "You are not authorized to view the page you requested.", flash[:alert]
  end

  # --- 4. Update Action Tests ---

  test "should update membership and associated nested attributes" do
    login_as(@regular_user, "passwor2")

    patch directory_url(@person), params: { membership: {
                                             StreetAddress: "999 New Address St",
                                             City: "South Burlington",
                                             people_attributes: {
                                               id: @person.id,
                                               FirstName: "Alice Updated",
                                               LastName: "Smith"
                                             }
                                           }
                                          }

    assert_redirected_to directory_path(@person)
    assert_equal "Directory profile updated.", flash[:notice]

    @membership.reload
    @person.reload
    assert_equal "999 New Address St", @membership.StreetAddress
    assert_equal "Alice Updated", @person.FirstName
  end

  test "should render edit with unprocessable_entity on failed update" do
    login_as(@regular_user, "passwor2")

    # Stub update to fail so we can verify the render response
    Membership.any_instance.stubs(:update).returns(false) if respond_to?(:stubs)

    patch directory_url(@person), params: {
      membership: { StreetAddress: "" }
    }

    assert_response :unprocessable_entity
  end

  private

  # Simple helper if Devise or custom helper isn't loaded automatically
  def sign_in(user)
    # Adjust according to your application's authentication helper (e.g., Warden, Devise, or custom session)
    ApplicationController.any_instance.stubs(:current_user).returns(user) if respond_to?(:stubs)
  end
end
