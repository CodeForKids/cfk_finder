require 'test_helper'

class ParentsControllerTest < ActionController::TestCase
  setup do
    @parent = parents(:one)
    sign_in(@parent.user)

    @parent2 = parents(:two)
    @no_role_id = users(:no_role_id_parent)
  end

  ########################################
  # Access to create/new without role id
  ########################################

  test "should get new when user doesn't has a role id" do
    sign_in(@no_role_id)

    get :new
    assert_response :success
  end

  test "should create parent when user doesn't has a role id" do
    sign_in(@no_role_id)

    assert_difference('Parent.count') do
      post :create, parent: { first_name: "John", last_name: "Smith" }
    end

    assert_response :redirect
    assert_redirected_to parent_path(assigns(:parent))
    assert_equal User.find(@no_role_id.id).role_id, assigns(:parent).id
  end

  ##################
  # Has Access Tests
  ##################

  test "should redirect from new when user has a role id" do
    get :new
    assert_response :redirect
  end

  test "should not create parent when user has a role id" do
    assert_no_difference('Parent.count') do
      post :create, parent: { first_name: "", last_name: "Chartrand" }
    end
    assert_redirected_to parent_path(@parent)
  end

  test "should show parent" do
    get :show, id: @parent
    assert_response :success
    parent = assigns(:parent)
    assert_equal parent.first_name, @parent.first_name
    assert_equal parent.last_name, @parent.last_name
  end

  test "should get edit" do
    get :edit, id: @parent
    assert_response :success
  end

  test "should update parent" do
    patch :update, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    assert_redirected_to parent_path(assigns(:parent))

    parent = assigns(:parent)
    assert_equal parent.first_name, "Josh"
    assert_equal parent.last_name, "Chartrand"
  end

  test "should not update parent" do
    patch :update, id: @parent, parent: { first_name: "", last_name: "Chartrand" }

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:parent).errors.full_messages.to_sentence
  end

  test "should destroy parent" do
    assert_difference('Parent.count', -1) do
      delete :destroy, id: @parent
    end

    assert_redirected_to root_url
  end

  ########################################
  # No Access Tests From Another Parent
  ########################################

  test "should not show parent" do
    sign_in(@parent2.user)

    get :show, id: @parent
    assert_response :redirect
    assert_redirected_to parent_path(@parent2)
  end

  test "should not get edit for another" do
    sign_in(@parent2.user)

    get :edit, id: @parent
    assert_response :redirect
    assert_redirected_to parent_path(@parent2)
  end

  test "should not update another parent" do
    sign_in(@parent2.user)
    patch :update, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    assert_redirected_to parent_path(@parent2)

    parent = Parent.find(@parent.id)
    assert_equal parent.first_name, @parent.first_name
    assert_equal parent.last_name, @parent.last_name
  end

  test "should not destroy another parent" do
    sign_in(@parent2.user)

    assert_no_difference('Parent.count') do
      delete :destroy, id: @parent
    end

    assert_redirected_to parent_path(@parent2)
  end

end
