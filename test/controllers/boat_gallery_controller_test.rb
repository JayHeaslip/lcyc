require "test_helper"

class BoatGalleryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:three)
    login_as(@user, "passwor3")
    @boat1 = boats(:boat1)
    @boat2 = boats(:boat2)
    @boat_without_photo = boats(:boat3)

    # Attach profile pictures to the first two records
    file = fixture_file_upload("test/fixtures/files/lcyc.jpg", "image/png")
    @boat1.photo.attach(file)
    @boat2.photo.attach(file)
  end

  test "should get index and assign boats by Name" do
    get boat_gallery_url

    assert_response :success
    assert_not_nil assigns(:boats)

    # Verifies only boats with attachments are returned
    assert_includes assigns(:boats), @boat1
    assert_includes assigns(:boats), @boat2
    refute_includes assigns(:boats), @boat_without_photo

    # Verifies ordering
    assert_equal [ @boat1, @boat2 ], assigns(:boats).to_a
  end
end
