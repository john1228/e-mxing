module Gyms
  class BaseController < ApplicationController
    before_action :verify_coach
    private
    def verify_coach
      @coach = Coach.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看到教练不存在') if @coach.nil?
    end
  end
end
