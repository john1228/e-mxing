module Gyms
  class CoursesController < BaseController
    before_action :fetch_course, only: [:coach, :comments, :concern]
    before_action :verify_auth_token, only: [:buy, :concern, :show]

    def index
      render json: Success.new(
                 courses: @coach.courses.joins('LEFT JOIN concerneds on concerneds.course_id=courses.id').page(params[:page]||1).collect { |course| {
                     id: course.id,
                     name: course.name,
                     cover: (course.course_image.first.thumb.url rescue ''),
                     price: course.price,
                     during: course.during,
                     type: course.type,
                     concerned: course.concerned.count,
                     top: course.top||0
                 } })
    end

    def show
      course = Course.find_by(id: params[:id])
      if course.blank?
        render json: Failure.new('您查看到课程不存在')
      else
        render json: Success.new(course: course.as_json.merge(
                                     concerned: course.concerned.find_by(user: @user).blank? ? 0 : 1,
                                     comments: {
                                         count: course.comments.count,
                                         latest: course.comments.first.as_json
                                     }
                                 ))
      end
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
      if params[:page].eql?('1')
        render json: Success.new(comments: {
                                     count: @course.comments.count,
                                     items: @course.comments.page(params[:page])
                                 })
      else
        render json: Success.new(comments: {items: @course.comments.page(params[:page])})
      end
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
