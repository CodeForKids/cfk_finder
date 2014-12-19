require 'test_helper'

class ParentsControllerTest < ActionController::TestCase
  setup do
    @parent = parents(:one)
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

    assert_difference(['Parent.count', 'Activity.count']) do
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
    sign_in(@parent.user)

    get :new
    assert_response :redirect
  end

  test "should not create parent when user has a role id" do
    sign_in(@parent.user)

    assert_no_difference(['Parent.count', 'Activity.count']) do
      post :create, parent: { first_name: "", last_name: "Chartrand" }
    end
    assert_redirected_to parent_path(@parent)
  end

  test "should show parent" do
    sign_in(@parent.user)

    get :show, id: @parent
    assert_response :success
    parent = assigns(:parent)
    assert_equal parent.first_name, @parent.first_name
    assert_equal parent.last_name, @parent.last_name
  end

  test "should get edit" do
    sign_in(@parent.user)

    get :edit, id: @parent
    assert_response :success
  end

  test "should update parent" do
    sign_in(@parent.user)

    assert_difference ('Activity.count') do
      patch :update, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    end

    assert_redirected_to parent_path(assigns(:parent))
    parent = assigns(:parent)
    assert_equal parent.first_name, "Josh"
    assert_equal parent.last_name, "Chartrand"

    # Checks Activity for the proper parameters
    activity = Activity.first
    check_activities(activity, ["first_name", "last_name"], ["updated_at"])
  end

  test "should not update parent" do
    sign_in(@parent.user)

    assert_no_difference ('Activity.count') do
      patch :update, id: @parent, parent: { first_name: "", last_name: "Chartrand" }
    end

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:parent).errors.full_messages.to_sentence
  end

  test "should destroy parent" do
    sign_in(@parent.user)

    assert_difference ('Activity.count') do
      assert_difference('Parent.count', -1) do
        delete :destroy, id: @parent
      end
    end

    assert_redirected_to root_url
  end

  #############
  # JSON Tests
  #############

  test "should show parent as json" do
    api_sign_in(@parent)

    get :show, id: @parent, format: :json
    assert_response :success
    parent = JSON.parse response.body
    json_has_keys(parent, :id, :first_name, :last_name, :email, :address, :kids, :updated_at, :created_at)
    json_has_keys(parent["address"], :address1, :address2, :city, :province, :country, :postal_code)
    json_has_keys(parent["kids"].first, :id, :first_name, :last_name, :gender, :parent_id, :updated_at, :created_at)
  end

  test "should update parent as json" do
    api_sign_in(@parent)

    assert_difference ('Activity.count') do
      patch :update, format: :json, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    end

    assert_response :success
  end

  test "should not update parent as json" do
    api_sign_in(@parent)

    assert_no_difference ('Activity.count') do
      patch :update, format: :json, id: @parent, parent: { first_name: "", last_name: "Chartrand" }
    end

    assert_response 422
    json = JSON.parse response.body
    assert_equal ["can't be blank"], json["errors"]["first_name"]
  end

  test "should destroy parent as json" do
    api_sign_in(@parent)

    assert_difference('Parent.count', -1) do
      delete :destroy, id: @parent, format: :json
    end
    assert_response :success
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

    assert_no_difference ('Activity.count') do
      patch :update, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    end

    assert_redirected_to parent_path(@parent2)

    parent = Parent.find(@parent.id)
    assert_equal parent.first_name, @parent.first_name
    assert_equal parent.last_name, @parent.last_name
  end

  test "should not destroy another parent" do
    sign_in(@parent2.user)

    assert_no_difference(['Parent.count', 'Activity.count']) do
      delete :destroy, id: @parent
    end

    assert_redirected_to parent_path(@parent2)
  end

  ########################################
  # No Access Tests Without sign in
  ########################################

  test "should not show parent without signin" do
    get :show, id: @parent
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should not get edit without signin" do
    get :edit, id: @parent
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should not update without signin" do
    assert_no_difference ('Activity.count') do
      patch :update, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    end
    assert_redirected_to new_user_session_path

    parent = Parent.find(@parent.id)
    assert_equal parent.first_name, @parent.first_name
    assert_equal parent.last_name, @parent.last_name
  end

  test "should not destroy without signin" do
    assert_no_difference(['Parent.count', 'Activity.count']) do
      delete :destroy, id: @parent
    end

    assert_redirected_to new_user_session_path
  end

  ##############################################
  # No Access Tests From Another Parent As Json
  ##############################################

  test "should not show parent as json" do
    api_sign_in(@parent2)

    get :show, id: @parent, format: :json
    assert_response :unauthorized
  end

  test "should not update another parent as json" do
    api_sign_in(@parent2)

    assert_no_difference ('Activity.count') do
      patch :update, format: :json, id: @parent, parent: { first_name: "Josh", last_name: "Chartrand" }
    end

    assert_response :unauthorized
  end

  test "should not destroy another parent as json" do
    api_sign_in(@parent2)

    assert_no_difference(['Parent.count', 'Activity.count']) do
      delete :destroy, format: :json, id: @parent
    end

    assert_response :unauthorized
  end

end
