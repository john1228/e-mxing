module Agency
  class CoursesController < BaseController
    def index
      user = Rails.cache.fetch(request.headers[:token])
      render json: Success.new(
                 courses: Sku.online.
                     select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]||(user.place.lonlat.x rescue 0)} #{params[:lat]||(user.place.lonlat.y rescue 0)})') as distance").
                     where(seller_id: @agency.id).
                     where("sku LIKE 'SC%'").
                     order(id: :desc).page(params[:page]||1)
             )
    end
  end
end
