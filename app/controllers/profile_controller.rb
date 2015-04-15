class ProfileController < ApplicationController
  include LoginManager

  def index
    render json: {code: 1, data: {profile: @user.profile.as_json}}
  end

  def complete
    user = User.new(username: @mobile, password: params[:password], name: params[:name], mobile: @mobile)
    if user.save
      Rails.cache.write(user.token,)
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
  def profile_params
    params.permit(:name, :birthday, :avatar, :signature, :gender, :identity, :birthday, :address, :interests, :target, :skill, :often)
  end
end
