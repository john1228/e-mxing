module Gyms
  class CoursesController < BaseController
    before_action :fetch_course, only: :coach
    before_action :verify_auth_token, only: :buy

    def index
      render json: {
                 code: 1,
                 data: {courses: @coach.courses.page(params[:page]||1).collect { |course| course.as_json }}
             }
    end

    def buy
      order = @user.orders.new(order_params)
      if order.save
        render json: {code: 1}
      else
        render json: {code: 0, message: '购买课程失败'}
      end
    end

    def coach
      render json: {code: 1, data: {coach: @course.coach.summary_json}}
    end

    private
    def fetch_course
      @course = Course.find_by(id: params[:course])
      render json: {code: 0, message: '课程不存在'} if @course.blank?
    end

    def verify_auth_token
      @user = Rails.cache.read(request.headers[:token])
      render json: {code: -1, message: '您还未登录'} if @user.blank?
    end

    def order_params
      params.permit(:contact_name, :contact_phone, :coupons, :bea, :pay_type, :item)
    end
  end
end
