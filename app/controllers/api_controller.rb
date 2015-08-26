class ApiController < ApplicationController
  before_action :verify_auth_token, only: [:create, :update, :destroy, :upload, :logout]
  before_action :find_user, except: [:create, :update, :destroy, :upload]
  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '您还未登录'} if @user.nil?
  end

  def find_user
    if params[:mxid].present?
      @user = User.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看到用户不存在') if @user.nil?
    end
  end
end
