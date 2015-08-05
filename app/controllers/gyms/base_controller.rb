module Gyms
  class BaseController < ApplicationController
    before_action :verify_coach, only: :index
    private
    def verify_coach
      @coach = Coach.find_by_mxid(params[:mxid])
      render json: Success.new('您查看到教练不存在') if @coach.nil?
    end
  end
end
