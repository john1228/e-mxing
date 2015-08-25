module Agency
  class CoursesController < BaseController
    def index
      render json: Success.new(
                 courses: Sku.online.
                     select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
                     where(seller_id: @agency.id).
                     where("sku LIKE 'SC%'").
                     order(id: :desc).page(params[:page]||1)
             )
    end
  end
end
