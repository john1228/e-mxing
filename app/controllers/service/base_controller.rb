module Service
  class BaseController < ApplicationController
    before_action :verify_coach
    private
    def verify_coach
      @service = Service.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看到教练不存在') if @service.nil?
    end
  end
end
