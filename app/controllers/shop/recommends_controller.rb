module Shop
  class RecommendsController < ApplicationController
    #私教评论列表
    def index
      case params[:type]
        when 'course'
          render json: Success.new(
                     course: Sku.recommended.page(params[:page]||1)
                 )
        when 'coach'
          render json: Success.new(
                     course: Coach.recommended.page(params[:page]||1).map { |coach|
                       coach.summary_json.merge(
                           tip: coach.recommend.recommended_tip,
                           courses: coach.course.count,
                           address: coach.service.address,
                           distance: coach.service.place.
                               lonlat.distance(RGeo::Geographic.spherical_factory(:srid => 4326).point(params[:lng], params[:lat]))

                       )
                     }
                 )
        when 'buy'
          render json: Success.new(course: Sku.order(orders_count: :desc).page(params[:page]||1))
        else
          render json: Failure.new('非法请求')
      end
    end
  end
end
