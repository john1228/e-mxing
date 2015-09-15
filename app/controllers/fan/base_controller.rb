module Fan
  class BaseController < ApplicationController
    before_action :verify_auth_token
    private
    def verify_auth_token
      @enthusiast = Enthusiast.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看到用户不存在') if @enthusiast.nil?
    end
  end
end
