module Gyms
  class CoursesController < BaseController
    def index
      if params[:version].present?
        render json: Success.new(
                   courses: Sku.online.where(seller_id: @coach.id).where("sku LIKE 'CC%'").order(id: :desc).page(params[:page]||1)
               )
      else
        render json: Success.new(
                   courses: @coach.courses.where(status: Course::STATUS[:online]).order(id: :desc).page(params[:page]||1)
               )
      end
    end

    def show
      course = Course.find_by(id: params[:id], status: Course::STATUS[:online])
      if course.blank?
        render json: Failure.new('您查看到课程已下架')
      else
        user = Rails.cache.fetch(request.headers[:token])
        render json: Success.new(course: course.as_json.merge(
                                     concerned: course.concerns.find_by(user: user).blank? ? 0 : 1,
                                     comments: {
                                         count: 0,
                                         latest: {}
                                     }
                                 ))
      end
    end

    def buy
      render json: Failure.new('您使用到版本已')
    end

    def coach
      coach = Course.find_by(id: params[:id]).coach
      render json: Success.new(coach: {
                                   mxid: coach.profile.mxid,
                                   name: coach.profile.name||'',
                                   avatar: coach.profile.avatar.thumb.url,
                                   gender: coach.profile.gender||1,
                                   age: coach.profile.age,
                                   signature: coach.profile.signature,
                                   tags: coach.profile.tags,
                                   mobile: coach.mobile,
                                   score: coach.score
                               })
    end

    def comments
      if params[:page].eql?('1')
        render json: Success.new(comments: {
                                     count: 0,
                                     items: {}
                                 })
      else
        render json: Success.new(comments: {items: {}})
      end
    end

  end
end
