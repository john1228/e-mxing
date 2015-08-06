module Gyms
  class CoursesController < BaseController
    def index
      render json: Success.new(
                 courses: Sku.online.where(seller_id: @coach.id).where("sku LIKE 'CC%'").order(id: :desc).page(params[:page]||1)
             )
    end
  end
end
