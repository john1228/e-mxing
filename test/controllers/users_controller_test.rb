require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should post regist" do
    post :regist
    assert_response :success
    assert_not_nil assigns(:coaches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gyms" do
    assert_difference('Coach.count') do
      post :create, gyms: {address: @coach.address, birthday: @coach.birthday, gender: @coach.gender, icon: @coach.icon, indentity: @coach.indentity, level: @coach.level, name: @coach.name, signature: @coach.signature}
    end

    assert_redirected_to coach_path(assigns(:gyms))
  end

  test "should show gyms" do
    get :show, id: @coach
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @coach
    assert_response :success
  end

  test "should update gyms" do
    patch :update, id: @coach, gyms: {address: @coach.address, birthday: @coach.birthday, gender: @coach.gender, icon: @coach.icon, indentity: @coach.indentity, level: @coach.level, name: @coach.name, signature: @coach.signature}
    assert_redirected_to coach_path(assigns(:gyms))
  end

  test "should destroy gyms" do
    assert_difference('Coach.count', -1) do
      delete :destroy, id: @coach
    end

    assert_redirected_to coaches_path
  end
end
