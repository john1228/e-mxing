module Gyms
  class BaseController < ApplicationController
    before_action :verify_coach
    before_action :check_version, except: :index
    private
    def verify_coach
      @coach = Coach.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看到教练不存在') if @coach.nil?
    end

    def check_version
      render json: Failure.new('版本太低，请更新应用再使用') if params[:version].present?
    end
  end
end
