module Mine
  class BaseController < ApplicationController
    before_action :verify_auth_token
    private
    def verify_auth_token
      @user = Rails.cache.read(request.headers[:token])
      logger.info "用户TOKEN::#{request.headers[:token]}"
      render json: Failure.new(-1, '您还没有登录') if @user.nil?
    end
  end
end
