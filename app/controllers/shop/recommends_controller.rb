module Shop
  class RecommendsController < ApplicationController
    #私教评论列表
    def index
      city = URI.decode(request.headers[:city]) rescue '上海'
      case params[:type]
        when 'course'
          render json: Success.new(
                     course: Sku.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").where('address LIKE ?', city + '%').recommended.page(params[:page]||1).map { |sku|
                       sku.as_json.merge(store: sku.store)
                     }
                 )
        when 'coach'
          services = Profile.where('address LIKE ? AND IDENTITY=2', city + '%').pluck(:user_id)
          render json: Success.new(
                     course: Coach.includes(:service_member).where(service_members: {service_id: services}).recommended.page(params[:page]||1).map { |coach|
                       coach.summary_json.merge(
                           tip: coach.recommend.recommended_tip,
                           courses: coach.courses.count,
                           address: coach.service.profile.address,
                           coordinate: {
                               lng: coach.service.place.lonlat.x,
                               lat: coach.service.place.lonlat.y,
                           }
                       )
                     }
                 )
        when 'buy'
          render json: Success.new(course: Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").where('address LIKE ? AND status=1', city + '%').order(orders_count: :desc).page(params[:page]||1).map { |sku|
                                     sku.as_json.merge(buyers: sku.orders_count)
                                   })
        else
          render json: Failure.new('非法请求')
      end
    end
  end
end
