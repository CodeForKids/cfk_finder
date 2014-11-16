require 'test_helper'

class KidsControllerTest < ActionController::TestCase
  setup do
    @kid = kids(:one)
    @parent = parents(:one)
    @parent2 = parents(:two)

    sign_in(@parent.user)
  end

  ##################
  # Has Access Tests
  ##################

  test "should get new" do
    get :new, parent_id: @parent
    assert_response :success
  end

  test "should create kid" do
    assert_difference('Kid.count') do
      post :create, parent_id: @parent, kid: { date_of_birth: @kid.date_of_birth, first_name: @kid.first_name, gender: @kid.gender, last_name: @kid.last_name }
    end
    assert_redirected_to parent_kid_path(@parent, assigns(:kid))
  end

  test "should not create kid" do
    assert_no_difference('Kid.count') do
      post :create, parent_id: @parent, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }
    end
    assert_template :new
    assert_equal "First name can't be blank", assigns(:kid).errors.full_messages.to_sentence
  end

  test "should show kid" do
    get :show, parent_id: @parent, id: @kid
    assert_response :success
  end

  test "should get edit" do
    get :edit, parent_id: @parent, id: @kid
    assert_response :success
  end

  test "should update kid" do
    patch :update, parent_id: @parent, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: @kid.first_name, gender: @kid.gender, last_name: @kid.last_name }
    assert_redirected_to parent_kid_path(@parent, assigns(:kid))
  end

  test "should not update kid" do
    patch :update, parent_id: @parent, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:kid).errors.full_messages.to_sentence
  end

  test "should destroy kid" do
    assert_difference('Kid.count', -1) do
      delete :destroy, parent_id: @parent, id: @kid
    end
    assert_redirected_to parent_path(@parent)
  end

  ######################
  # Has No Access Tests
  ######################

  test "should not show kid for another parent's kid" do
    sign_in(@parent2.user)

    get :show, parent_id: @parent, id: @kid
    assert_response :redirect
    assert_redirected_to @parent2
  end

  test "should not get edit for another parent's kid" do
    sign_in(@parent2.user)

    get :edit, parent_id: @parent, id: @kid
    assert_response :redirect
    assert_redirected_to @parent2
  end

  test "should not update another parent's kid" do
    sign_in(@parent2.user)

    patch :update, parent_id: @parent, id: @kid, kid: { first_name: "Not_Update" }
    assert_response :redirect
    assert_redirected_to @parent2
  end

  test "should not destroy kid for parent's kid" do
    sign_in(@parent2.user)

    assert_no_difference('Kid.count') do
      delete :destroy, parent_id: @parent, id: @kid
    end
    assert_response :redirect
    assert_redirected_to @parent2
  end

end
