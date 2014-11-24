require 'test_helper'

class KidsControllerTest < ActionController::TestCase
  setup do
    @kid = kids(:one)
    @parent = parents(:one)
    @parent2 = parents(:two)
  end

  ##################
  # Has Access Tests
  ##################

  test "should get new" do
    sign_in(@parent.user)

    get :new, parent_id: @parent
    assert_response :success
  end

  test "should create kid" do
    sign_in(@parent.user)

    assert_difference(['Kid.count', 'Activity.count']) do
      post :create, parent_id: @parent, kid: { date_of_birth: @kid.date_of_birth, first_name: @kid.first_name, gender: @kid.gender, last_name: @kid.last_name }
    end
    assert_redirected_to parent_kid_path(@parent, assigns(:kid))
  end

  test "should not create kid" do
    sign_in(@parent.user)

    assert_no_difference(['Kid.count', 'Activity.count']) do
      post :create, parent_id: @parent, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }
    end
    assert_template :new
    assert_equal "First name can't be blank", assigns(:kid).errors.full_messages.to_sentence
  end

  test "should show kid" do
    sign_in(@parent.user)

    get :show, parent_id: @parent, id: @kid
    assert_response :success
  end

  test "should get edit" do
    sign_in(@parent.user)

    get :edit, parent_id: @parent, id: @kid
    assert_response :success
  end

  test "should update kid" do
    sign_in(@parent.user)

    assert_difference ('Activity.count') do
      patch :update, parent_id: @parent, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: "bobby", gender: @kid.gender, last_name: @kid.last_name }
    end

    assert_redirected_to parent_kid_path(@parent, assigns(:kid))
  end

  test "should not update kid" do
    sign_in(@parent.user)

    assert_no_difference ('Activity.count') do
      patch :update, parent_id: @parent, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }
    end

    assert_template :edit
    assert_equal "First name can't be blank", assigns(:kid).errors.full_messages.to_sentence
  end

  test "should destroy kid" do
    sign_in(@parent.user)

    assert_difference('Activity.count') do
      assert_difference('Kid.count', -1) do
        delete :destroy, parent_id: @parent, id: @kid
      end
    end
    assert_redirected_to parent_path(@parent)
  end

  ###########################
  # Has Access Tests As Json
  ###########################

  test "should create kid as json" do
    api_sign_in(@parent)

    assert_difference(['Kid.count', 'Activity.count']) do
      post :create, parent_id: @parent, kid: { date_of_birth: @kid.date_of_birth, first_name: @kid.first_name, gender: @kid.gender, last_name: @kid.last_name }, format: :json
    end
    assert_response :success

    activity = Activity.last
    assert_equal "created", activity.action
    assert_equal Kid.last, activity.trackable
  end

  test "should not create kid as json" do
    api_sign_in(@parent)

    assert_no_difference(['Kid.count', 'Activity.count']) do
      post :create, parent_id: @parent, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }, format: :json
    end
    assert_response 422
    json = JSON.parse response.body
    assert_equal ["can't be blank"], json["errors"]["first_name"]
  end

  test "should show kid as json" do
    api_sign_in(@parent)

    get :show, parent_id: @parent, id: @kid, format: :json
    assert_response :success

    json_has_keys(JSON.parse(response.body), :id, :first_name, :last_name, :gender, :parent_id, :updated_at, :created_at)
  end

  test "should update kid as json" do
    api_sign_in(@parent)

    assert_difference ('Activity.count') do
      patch :update, parent_id: @parent, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: "bobby", gender: @kid.gender, last_name: @kid.last_name }, format: :json
    end

    assert_response :success

    # Checks Activity for the proper parameters
    activity = Activity.last
    check_activities(activity, ["first_name"], ["last_name", "cupdated_at"])
    assert_equal "updated", activity.action
    assert_equal @kid, activity.trackable
  end

  test "should not update kid as json" do
    api_sign_in(@parent)

    assert_no_difference ('Activity.count') do
      patch :update, parent_id: @parent, id: @kid, kid: { date_of_birth: @kid.date_of_birth, first_name: "", gender: @kid.gender, last_name: @kid.last_name }, format: :json
    end

    assert_response 422
    json = JSON.parse response.body
    assert_equal ["can't be blank"], json["errors"]["first_name"]
  end

  test "should destroy kid as json" do
    api_sign_in(@parent)
    assert_difference ('Activity.count') do
      assert_difference('Kid.count', -1) do
        delete :destroy, parent_id: @parent, id: @kid, format: :json
      end
    end
    assert_response :success

    activity = Activity.last
    assert_equal "destroyed", activity.action
    assert_equal nil, activity.trackable
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

    assert_no_difference ('Activity.count') do
      patch :update, parent_id: @parent, id: @kid, kid: { first_name: "Not_Update" }
    end
    assert_response :redirect
    assert_redirected_to @parent2
  end

  test "should not destroy kid for parent's kid" do
    sign_in(@parent2.user)

    assert_no_difference(['Kid.count', 'Activity.count']) do
      delete :destroy, parent_id: @parent, id: @kid
    end
    assert_response :redirect
    assert_redirected_to @parent2
  end

  ##############################
  # Has No Access Tests As Json
  ##############################

  test "should not show kid for another parent's kid as json" do
    api_sign_in(@parent2)

    get :show, parent_id: @parent, id: @kid, format: :json
    assert_response :unauthorized
  end

  test "should not get edit for another parent's kid as json" do
    api_sign_in(@parent2)

    get :edit, parent_id: @parent, id: @kid, format: :json
    assert_response :unauthorized
  end

  test "should not update another parent's kid as json" do
    api_sign_in(@parent2)

    assert_no_difference ('Activity.count') do
      patch :update, parent_id: @parent, id: @kid, kid: { first_name: "Not_Update" }, format: :json
    end
    assert_response :unauthorized
  end

  test "should not destroy kid for parent's kid as json" do
    api_sign_in(@parent2)

    assert_no_difference(['Kid.count', 'Activity.count']) do
      delete :destroy, parent_id: @parent, id: @kid, format: :json
    end
    assert_response :unauthorized
  end

end
