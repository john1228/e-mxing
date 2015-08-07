module Service
  class BaseController < ApplicationController
    before_action :verify_service
    private
    def verify_service
      @service = Service.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看的服务号不存在') if @service.nil?
    end
  end
end
