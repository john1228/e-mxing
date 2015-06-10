module Gyms
  class CoursesController < BaseController
    before_action :fetch_course, only: [:coach, :comments, :concern]
    before_action :verify_auth_token, only: [:buy, :concern]

    def index
      render json: Success.new({courses: @coach.courses.page(params[:page]||1)})
    end

    def show

    end

    def buy
      order = @user.orders.new(order_params)
      if order.save
        render json: Success.new
      else
        render json: Failure.new('购买课程失败')
      end
    end

    def concern
      concerned = @course.concerned.new(user: @user)
      if concerned.save
        render json: Success.new
      else
        render json: Failure.new('关注课程失败')
      end
    end

    def coach
      render json: Success.new({coach: @course.coach.summary_json})
    end

    def comments
      render json: {code: 1, data: {comments: @course.comments.page(params[:page]||1).collect { |comment| comment.as_json }}}
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
