class ProfileController < ApplicationController
  before_action :verify_auth_token, only: :update


  def index
    render json: {code: 1, data: {profile: @user.as_json}}
  end

  def complete
    user = User.new(mobile: @mobile, password: params[:password], name: params[:name])
    if user.save
      Rails.cache.write(user.token, user)
      render json: {code: 1, data: {user: user.summary_json}}
    else
      render json: {code: 0, message: '创建用户失败'}
    end
  end

  def update
    if @user.profile.update(profile_params)
      render json: {code: 1}
    else
      render json: {code: 0, message: '修改失败'}
    end
  end

  private
  def verify_auth_token
    @user = Rails.cache.read(request.headers[:token])
    render json: Failure.new(-1, '您还没有登录') if @user.nil?
  end

  def profile_params
    params.permit(:name, :birthday, :avatar, :signature, :gender, :birthday, :address, :interests, :target, :skill, :often)
  end
end
