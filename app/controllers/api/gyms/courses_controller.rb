module Api
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
end
