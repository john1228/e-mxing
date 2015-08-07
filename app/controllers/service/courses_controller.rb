module Service
  class CoursesController < BaseController
    def index
      render json: Success.new(
                 courses: Sku.online.where(seller_id: @service.id).where("sku LIKE 'SC%'").order(id: :desc).page(params[:page]||1)
             )
    end
  end
end
