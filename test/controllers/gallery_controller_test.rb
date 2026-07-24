require "test_helper"

class GalleryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:three)
    login_as(@user, 'passwor3')
    @person1 = people(:jim)
    @person2 = people(:bob)
    @person_without_photo = people(:jill)

    # Attach profile pictures to the first two records
    file = fixture_file_upload("test/fixtures/files/lcyc.jpg", "image/png")
    @person1.profile_picture.attach(file)
    @person2.profile_picture.attach(file)
  end

  test "should get index and assign people ordered by LastName and FirstName" do
    get gallery_url

    assert_response :success
    assert_not_nil assigns(:people)

    # Verifies only people with attachments are returned
    assert_includes assigns(:people), @person1
    assert_includes assigns(:people), @person2
    refute_includes assigns(:people), @person_without_photo

    # Verifies ordering: Adams (Bob) should come before Zimmerman (Alice)
    assert_equal [@person2, @person1], assigns(:people).to_a
  end
end
