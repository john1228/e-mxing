module Gyms
  class CoursesController < BaseController
    def index
      user = Rails.cache.fetch(request.headers[:token])
      render json: Success.new(
                 courses: Sku.online.
                     select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]||(user.place.lonlat.x rescue 0)} #{params[:lat]||(user.place.lonlat.y rescue 0)})') as distance").
                     where(seller_id: @coach.id).
                     order(id: :desc).page(params[:page]||1)
             )
    end

    def show
      course = Sku.online.find_by(id: params[:id])
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
      coach = Coach.find_by(id: Sku.find_by(id: params[:id]).seller_id)
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
