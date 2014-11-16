require 'test_helper'

class KidsControllerTest < ActionController::TestCase
  setup do
    @kid = kids(:one)
    @customer = customers(:one)
    @customer2 = customers(:two)

    sign_in(@customer.user)
  end

  ##################
  # Has Access Tests
  ##################

  test "should get new" do
    get :new, customer_id: @customer
    assert_response :success
  end

  test "should create kid" do
    assert_difference('Kid.count') do
      post :create, customer_id: @customer, kid: { date_of_birth: @kid.date_of_birth, first_name: @kid.first_name, gender: @kid.gender, last_name: @kid.last_name }
    end
    assert_redirected_to customer_kid_path(@customer, assigns(:kid))
  end

  test "should not create kid" do
    assert_no_difference('Kid.count') do
      post :create, customer_id: @customer, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }
    end
    assert_template :new
    assert_equal "First name can't be blank", assigns(:kid).errors.full_messages.to_sentence
  end

  test "should show kid" do
    get :show, customer_id: @customer, id: @kid
    assert_response :success
  end

  test "should get edit" do
    get :edit, customer_id: @customer, id: @kid
    assert_response :success
  end

  test "should update kid" do
    patch :update, customer_id: @customer, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: @kid.first_name, gender: @kid.gender, last_name: @kid.last_name }
    assert_redirected_to customer_kid_path(@customer, assigns(:kid))
  end

  test "should not update kid" do
    patch :update, customer_id: @customer, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:kid).errors.full_messages.to_sentence
  end

  test "should destroy kid" do
    assert_difference('Kid.count', -1) do
      delete :destroy, customer_id: @customer, id: @kid
    end
    assert_redirected_to customer_kids_path(@customer)
  end

  ######################
  # Has No Access Tests
  ######################

  test "should not show kid for another parent's kid" do
    sign_in(@customer2.user)

    get :show, customer_id: @customer, id: @kid
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not get edit for another parent's kid" do
    sign_in(@customer2.user)

    get :edit, customer_id: @customer, id: @kid
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not update another parent's kid" do
    sign_in(@customer2.user)

    patch :update, customer_id: @customer, id: @kid, kid: { first_name: "Not_Update" }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not destroy kid for parent's kid" do
    sign_in(@customer2.user)

    assert_no_difference('Kid.count') do
      delete :destroy, customer_id: @customer, id: @kid
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

end
