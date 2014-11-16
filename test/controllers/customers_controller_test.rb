require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    @customer = customers(:one)
    sign_in(@customer.user)

    @customer2 = customers(:two)
    @no_role_id = users(:no_role_id_customer)
  end

  ########################################
  # Access to create/new without role id
  ########################################

  test "should get new when user doesn't has a role id" do
    sign_in(@no_role_id)

    get :new
    assert_response :success
  end

  test "should create customer when user doesn't has a role id" do
    sign_in(@no_role_id)

    assert_difference('Customer.count') do
      post :create, customer: { first_name: "John", last_name: "Smith", email: @no_role_id.email }
    end

    assert_response :redirect
    assert_redirected_to customer_path(assigns(:customer))
    assert_equal User.find(@no_role_id.id).role_id, assigns(:customer).id
  end

  ##################
  # Has Access Tests
  ##################

  test "should redirect from new when user has a role id" do
    get :new
    assert_response :redirect
  end

  test "should not create customer when user has a role id" do
    assert_no_difference('Customer.count') do
      post :create, customer: { first_name: "", last_name: "Chartrand", email: "josh@example.com" }
    end
    assert_redirected_to customer_path(@customer)
  end

  test "should show customer" do
    get :show, id: @customer
    assert_response :success
    customer = assigns(:customer)
    assert_equal customer.first_name, @customer.first_name
    assert_equal customer.last_name, @customer.last_name
    assert_equal customer.email, @customer.email
  end

  test "should get edit" do
    get :edit, id: @customer
    assert_response :success
  end

  test "should update customer" do
    patch :update, id: @customer, customer: { first_name: "Josh", last_name: "Chartrand", email: "josh@example.com" }
    assert_redirected_to customer_path(assigns(:customer))

    customer = assigns(:customer)
    assert_equal customer.first_name, "Josh"
    assert_equal customer.last_name, "Chartrand"
    assert_equal customer.email, "josh@example.com"
  end

  test "should not update customer" do
    patch :update, id: @customer, customer: { first_name: "", last_name: "Chartrand", email: "josh@example.com" }

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:customer).errors.full_messages.to_sentence
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete :destroy, id: @customer
    end

    assert_redirected_to customers_path
  end

  ########################################
  # No Access Tests From Another Customer
  ########################################

  test "should not show customer" do
    sign_in(@customer2.user)

    get :show, id: @customer
    assert_response :redirect
    assert_redirected_to customer_path(@customer2)
  end

  test "should not get edit for another" do
    sign_in(@customer2.user)

    get :edit, id: @customer
    assert_response :redirect
    assert_redirected_to customer_path(@customer2)
  end

  test "should not update another customer" do
    sign_in(@customer2.user)

    patch :update, id: @customer, customer: { first_name: "Josh", last_name: "Chartrand", email: "josh@example.com" }
    assert_redirected_to customer_path(@customer2)

    customer = Customer.find(@customer.id)
    assert_equal customer.first_name, @customer.first_name
    assert_equal customer.last_name, @customer.last_name
    assert_equal customer.email, @customer.email
  end

  test "should not destroy another customer" do
    sign_in(@customer2.user)

    assert_no_difference('Customer.count') do
      delete :destroy, id: @customer
    end

    assert_redirected_to customer_path(@customer2)
  end

end
