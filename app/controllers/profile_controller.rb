class ProfileController < ApplicationController
  include CheckConcern
  include Easemob

  def index
    render json: {
               code: 1,
               data: {
                   profile: @user.profile.as_json
               }
           }
  end

  def complete
    user = User.new(username: @mobile, password: params[:password], name: params[:name])
    if user.save
      regist_single(user.mxid, params[:name])
      Rails.cache.write(user.token, user)
      render json: {
                 code: 1,
                 data: {
                     user: user.summary_json
                 }
             }
    else
      render json: {
                 code: 0,
                 message: '创建用户失败'
             }
    end
  end

  def update
    profile_params[:icon] = params[:File] unless params[:File].blank?
    if @user.profile.update(profile_params)
      update_nickname(@user.username, profile_params[:name]) unless profile_params[:name].blank?
      Rails.cache.write(@user.token, @user)
      render json: {
                 code: 1,
             }
    else
      render json: {
                 code: 0,
                 message: '修改失败'
             }
    end
  end


  private
  def profile_params
    params.permit(:name, :birthday, :avatar, :signature, :gender, :identity, :birthday, :address, :interests, :target, :skill, :often_stadium)
  end
end
