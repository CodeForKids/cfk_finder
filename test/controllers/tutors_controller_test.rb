require 'test_helper'

class TutorsControllerTest < ActionController::TestCase
  setup do
    @tutor = tutors(:one)
    sign_in(@tutor.user)

    @tutor2 = tutors(:two)
    @no_role_id = users(:no_role_id_tutor)
  end

  ########################################
  # Access to create/new without role id
  ########################################

  test "should get new when user doesn't has a role id" do
    sign_in(@no_role_id)

    get :new
    assert_response :success
  end

  test "should create tutor when user doesn't has a role id" do
    sign_in(@no_role_id)

    assert_difference('Tutor.count') do
      post :create, tutor: { first_name: "John", last_name: "Smith" }
    end

    assert_response :redirect
    assert_redirected_to tutor_path(assigns(:tutor))
    assert_equal User.find(@no_role_id.id).role_id, assigns(:tutor).id
  end

  ##################
  # Has Access Tests
  ##################

  test "should redirect from new when user has a role id" do
    get :new
    assert_response :redirect
  end

  test "should not create tutor when user has a role id" do
    assert_no_difference('Tutor.count') do
      post :create, tutor: { first_name: "", last_name: "Chartrand" }
    end
    assert_redirected_to tutor_path(@tutor)
  end

  test "should show tutor" do
    get :show, id: @tutor
    assert_response :success
    tutor = assigns(:tutor)
    assert_equal tutor.first_name, @tutor.first_name
    assert_equal tutor.last_name, @tutor.last_name
  end

  test "should get edit" do
    get :edit, id: @tutor
    assert_response :success
  end

  test "should update tutor" do
    patch :update, id: @tutor, tutor: { first_name: "Josh", last_name: "Chartrand" }
    assert_redirected_to tutor_path(assigns(:tutor))

    tutor = assigns(:tutor)
    assert_equal tutor.first_name, "Josh"
    assert_equal tutor.last_name, "Chartrand"
  end

  test "should not update tutor" do
    patch :update, id: @tutor, tutor: { first_name: "", last_name: "Chartrand" }

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:tutor).errors.full_messages.to_sentence
  end

  test "should destroy tutor" do
    assert_difference('Tutor.count', -1) do
      delete :destroy, id: @tutor
    end

    assert_redirected_to root_url
  end

  ########################################
  # No Access Tests From Another Tutor
  ########################################

  test "should not show tutor" do
    sign_in(@tutor2.user)

    get :show, id: @tutor
    assert_response :redirect
    assert_redirected_to tutor_path(@tutor2)
  end

  test "should not get edit for another tutor" do
    sign_in(@tutor2.user)

    get :edit, id: @tutor
    assert_response :redirect
    assert_redirected_to tutor_path(@tutor2)
  end

  test "should not update another tutor" do
    sign_in(@tutor2.user)
    patch :update, id: @tutor, tutor: { first_name: "Josh", last_name: "Chartrand" }
    assert_redirected_to tutor_path(@tutor2)

    tutor = Tutor.find(@tutor.id)
    assert_equal tutor.first_name, @tutor.first_name
    assert_equal tutor.last_name, @tutor.last_name
  end

  test "should not destroy another tutor" do
    sign_in(@tutor2.user)

    assert_no_difference('Tutor.count') do
      delete :destroy, id: @tutor
    end

    assert_redirected_to tutor_path(@tutor2)
  end

end
