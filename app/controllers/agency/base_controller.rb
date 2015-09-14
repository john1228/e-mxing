module Agency
  class BaseController < ApplicationController
    before_action :verify_agency, except: [:list, :hot]
    private
    def verify_agency
      @agency = Service.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看的服务号不存在') if @agency.nil?
    end
  end
end
