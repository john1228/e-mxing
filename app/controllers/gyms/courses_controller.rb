module Gyms
  class CoursesController < BaseController
    before_action :fetch_course, only: [:coach, :comments]
    before_action :verify_auth_token, only: :buy

    def index
      render json: Success.new(
                 courses: @coach.courses.page(params[:page]||1).collect { |course| {
                     id: course.id,
                     name: course.name,
                     cover: course.course_photos.first.present? ? course.course_photos.first.photo.thumb.url : '',
                     price: course.price,
                     during: course.during,
                     type: course.type,
                     guarantee: course.guarantee,
                     concerned: course.concerns.count,
                     top: course.top||0
                 } })
    end

    def show
      course = Course.find_by(id: params[:id])
      if course.blank?
        render json: Failure.new('您查看到课程不存在')
      else
        user = Rails.cache.fetch(request.headers[:token])
        render json: Success.new(course: course.as_json.merge(
                                     concerned: course.concerns.find_by(user: user).blank? ? 0 : 1,
                                     comments: {
                                         count: course.comments.count,
                                         latest: course.comments.first.blank? ? {} : course.comments.first.as_json
                                     }
                                 ))
      end
    end

    def buy
      order = @user.orders.new(order_params)
      if order.save
        render json: Success.new(order: {no: order.no, status: order.status})
      else
        render json: Failure.new('购买课程失败')
      end
    end


    def coach
      coach = @course.coach
      render json: Success.new({coach: {
                                   mxid: coach.profile.mxid,
                                   name: coach.profile.name||'',
                                   avatar: coach.profile.avatar.thumb.url,
                                   gender: coach.profile.gender||1,
                                   age: coach.profile.age,
                                   signature: coach.profile.signature,
                                   tags: coach.profile.tags,
                                   mobile: coach.mobile,
                                   score: coach.score
                               }})
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
