require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:canada)
  end

  # NO ACCESS NEEDED

  test "should get index" do
    get :index, tutor_id: @event.owner
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should show event" do
    get :show, tutor_id: @event.owner, id: @event
    assert_response :success
  end

  # SIGN IN REQURED BY TUTOR OR EVENT ORGANIZER

  test "should get new" do
    sign_in(@event.owner.user)
    get :new, tutor_id: @event.owner
    assert_response :success
  end

  test "should create event" do
    sign_in(@event.owner.user)

    assert_difference('Event.count') do
      post :create, tutor_id: @event.owner, event: { address_id: @event.address_id, description: @event.description, materials_needed: @event.materials_needed, name: @event.name, price: @event.price, spots_available: @event.spots_available, tax_rate: @event.tax_rate, type: @event.event_type }
    end

    assert_redirected_to [@event.owner, assigns(:event)]
  end

  # TEST NOT SIGNED IN / NOT TUTOR

  test "should not get new without signin" do
    get :new, tutor_id: @event.owner
    assert_redirected_to new_user_session_url
  end

  test "should not create event without signin" do
    assert_no_difference('Event.count') do
      post :create, tutor_id: @event.owner, event: { address_id: @event.address_id, description: @event.description, materials_needed: @event.materials_needed, name: @event.name, price: @event.price, spots_available: @event.spots_available, tax_rate: @event.tax_rate, type: @event.event_type }
    end
    assert_redirected_to new_user_session_url
  end

  test "should not get new as parent" do
    sign_in(parents(:one).user)
    get :new, tutor_id: @event.owner
    assert_redirected_to parents(:one)
  end

  test "should not create event as parent" do
    sign_in(parents(:one).user)
    assert_no_difference('Event.count') do
      post :create, tutor_id: @event.owner, event: { address_id: @event.address_id, description: @event.description, materials_needed: @event.materials_needed, name: @event.name, price: @event.price, spots_available: @event.spots_available, tax_rate: @event.tax_rate, type: @event.event_type }
    end
    assert_redirected_to parents(:one)
  end

  # SIGN IN REQURED BY OWNER

  test "should get edit" do
    sign_in(@event.owner.user)
    get :edit, tutor_id: @event.owner, id: @event
    assert_response :success
  end

  test "should update event" do
    sign_in(@event.owner.user)
    patch :update, tutor_id: @event.owner, id: @event, event: { address_id: @event.address_id, description: @event.description, materials_needed: @event.materials_needed, name: @event.name, price: @event.price, spots_available: @event.spots_available, tax_rate: @event.tax_rate, type: @event.event_type }
    assert_redirected_to [@event.owner, assigns(:event)]
  end

  test "should destroy event" do
    sign_in(@event.owner.user)

    assert_difference('Event.count', -1) do
      delete :destroy, tutor_id: @event.owner, id: @event
    end

    assert_redirected_to [@event.owner, :events]
  end

  # NOT SIGNED IN AS OWNER

  test "should not get edit as another tutor" do
    sign_in(tutors(:two).user)
    get :edit, tutor_id: @event.owner, id: @event
    assert_redirected_to tutors(:two)
  end

  test "should not update event as another tutor" do
    sign_in(tutors(:two).user)
    patch :update, tutor_id: @event.owner, id: @event, event: { address_id: @event.address_id, description: @event.description, materials_needed: @event.materials_needed, name: @event.name, price: @event.price, spots_available: @event.spots_available, tax_rate: @event.tax_rate, type: @event.event_type }
    assert_redirected_to tutors(:two)
  end

  test "should not destroy event as another tutor" do
    sign_in(tutors(:two).user)

    assert_no_difference('Event.count', -1) do
      delete :destroy, tutor_id: @event.owner, id: @event
    end

    assert_redirected_to tutors(:two)
  end

  # NOT SIGNED IN AS TUTOR

  test "should not get edit as a parent" do
    sign_in(parents(:one).user)
    get :edit, tutor_id: @event.owner, id: @event
    assert_redirected_to parents(:one)
  end

  test "should not update event as a parent" do
    sign_in(parents(:one).user)
    patch :update, tutor_id: @event.owner, id: @event, event: { address_id: @event.address_id, description: @event.description, materials_needed: @event.materials_needed, name: @event.name, price: @event.price, spots_available: @event.spots_available, tax_rate: @event.tax_rate, type: @event.event_type }
    assert_redirected_to parents(:one)
  end

  test "should not destroy event as a parent" do
    sign_in(parents(:one).user)

    assert_no_difference('Event.count', -1) do
      delete :destroy, tutor_id: @event.owner, id: @event
    end

    assert_redirected_to parents(:one)
  end
end
