require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    @parent = parents(:one)
  end

  test "should get index of home" do
    sign_in(@parent.user)

    get :index
    assert_equal @parent.address, assigns(:current_location)
    assert assigns(:events).count > 1, "Did not have at least 1 address"
    assert_equal "We detected your location to be Ottawa, please make sure this is correct.", flash[:notice]
  end

  test "should get index of home with no city" do
    @parent.address.update_attributes(city: nil)
    sign_in(@parent.user)

    get :index
    assert_equal @parent.address, assigns(:current_location)
    assert assigns(:events).count > 1, "Did not have at least 1 address"
    assert_equal "We detected your location automatically, please make sure it is correct.", flash[:notice]
    assert_equal @parent.user, User.current_user
  end

  test "should get index of home without location" do
    request.stubs(:location).returns(nil)

    get :index
    assert_not assigns(:current_location), "Had a current_location"
    assert assigns(:events).count > 1, "Did not have at least 1 address"
    assert_equal "We had an issue detecting your location, please find your location on the map.", flash[:error]
  end

  #################
  # Authenticate
  #################

  test "should not authenticate without password and email" do
    api_sign_in(@parent)

    post :authenticate, format: :json
    assert_response 400
    assert_equal @parent.user, User.current_user
  end

  test "should not authenticate with email and wrong password" do
    @request.headers["X-Entity-Password"] = "wrong"
    @request.headers["X-Entity-Email"] = @parent.email

    post :authenticate, format: :json
    assert_response 401
  end

  test "should not authenticate with wrong email and password" do
    @request.headers["X-Entity-Password"] = "12345678"
    @request.headers["X-Entity-Email"] = "fake@fake.com"

    post :authenticate, format: :json
    assert_response 401
  end

  test "should authenticate with email and password" do
    @request.headers["X-Entity-Password"] = "12345678"
    @request.headers["X-Entity-Email"] = @parent.email

    post :authenticate, format: :json
    assert_response 200
    assert_equal @parent.user.token_hash.as_json, JSON.parse(response.body)
  end

end
