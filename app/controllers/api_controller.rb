class ApiController < ApplicationController
  before_action :verify_auth_token, only: [:create, :update, :destroy, :upload]
  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '您还未登录'} if @user.nil?
  end
end
