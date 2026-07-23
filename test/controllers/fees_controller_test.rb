require "test_helper"

class FeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fee = fees(:fees1)
    login_as(users(:treasurer), "treasurer")
  end

  # --- GET #show ---
  test "should show fee" do
    get fee_url
    assert_response :success
    assert_not_nil assigns(:fee)
  end

  # --- GET #edit ---
  test "should get edit" do
    get edit_fee_url
    assert_response :success
    assert_not_nil assigns(:fee)
  end

  # --- PATCH/PUT #update (Success Path) ---
  test "should update fee with valid parameters" do
    patch fee_url, params: {
      fee: {
        active: 150,
        associate: 75,
        inactive: 50,
        senior: 100,
        mooring_fee: 200,
        mooring_replacement_fee: 500,
        drysail_fee: 120,
        skip_docks_assessment: false
      }
    }

    assert_redirected_to fee_url
    assert_equal "Successfully updated fees.", flash[:notice]

    # Verify changes were persisted
    @fee.reload
    assert_equal 150, @fee.active
    assert_equal 200, @fee.mooring_fee
  end

  # --- PATCH/PUT #update (Failure Path) ---
  test "should render edit with unprocessable entity on invalid update" do
    # Trigger a validation failure (assuming a presence or numericality validation on active)
    patch fee_url, params: {
      fee: {
        active: -50 # Or nil, depending on your Fee model validations
      }
    }

    assert_response :unprocessable_entity
    assert_template :edit
  end
end
