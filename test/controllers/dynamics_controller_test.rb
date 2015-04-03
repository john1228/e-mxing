require 'test_helper'

class DynamicsControllerTest < ActionController::TestCase
  setup do
    @dynamic = dynamics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic" do
    assert_difference('Dynamic.count') do
      post :create, dynamic: { film: @dynamic.film, image: @dynamic.image, message: @dynamic.message, user_id: @dynamic.user_id }
    end

    assert_redirected_to dynamic_path(assigns(:dynamic))
  end

  test "should show dynamic" do
    get :show, id: @dynamic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dynamic
    assert_response :success
  end

  test "should update dynamic" do
    patch :update, id: @dynamic, dynamic: { film: @dynamic.film, image: @dynamic.image, message: @dynamic.message, user_id: @dynamic.user_id }
    assert_redirected_to dynamic_path(assigns(:dynamic))
  end

  test "should destroy dynamic" do
    assert_difference('Dynamic.count', -1) do
      delete :destroy, id: @dynamic
    end

    assert_redirected_to dynamics_path
  end
end
