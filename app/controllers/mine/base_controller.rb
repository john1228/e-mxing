module Mine
  class BaseController < ApplicationController
    before_action :verify_auth_token
    private
    def verify_auth_token
      @me = Rails.cache.read(request.headers[:token])
      render json: Failure.new(-1, '您还没有登录') if @me.nil?
    end
  end
end
