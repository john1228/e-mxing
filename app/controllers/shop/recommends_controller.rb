module Shop
  class RecommendsController < ApplicationController
    #私教评论列表
    def index
      case params[:type]
        when 'course'
          render json: Success.new(
                     course: Sku.recommended.page(params[:page]||1).map { |sku|
                       sku.as_json.merge(store: sku.store)
                     }
                 )
        when 'coach'
          render json: Success.new(
                     course: Coach.recommended.page(params[:page]||1).map { |coach|
                       coach.summary_json.merge(
                           tip: coach.recommend.recommended_tip,
                           courses: coach.courses.count,
                           address: coach.service.address,
                           coordinate: {
                               lng: coach.service.place.lonlat.x,
                               lat: coach.service.place.lonlat.y,
                           }
                       )
                     }
                 )
        when 'buy'
          render json: Success.new(course: Sku.order(orders_count: :desc).page(params[:page]||1).map { |sku|
                                     sku.as_json.merge(buyers: sku.orders_count)
                                   })
        else
          render json: Failure.new('非法请求')
      end
    end
  end
end
