require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    @customer = customers(:one)
    sign_in(@customer.user)
  end

  test "should redirect from new when user has a role" do
    get :new
    assert_response :redirect
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post :create, customer: { first_name: "Josh", last_name: "Chartrand", email: "josh@example.com" }
    end

    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should not create customer" do
    assert_no_difference('Customer.count') do
      post :create, customer: { first_name: "", last_name: "Chartrand", email: "josh@example.com" }
    end

    assert_template :new
    assert_equal "First name can't be blank", assigns(:customer).errors.full_messages.to_sentence
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
end
