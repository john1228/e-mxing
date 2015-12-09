module Business
  module FaceToFaces
    class HomeController < BaseController
      def courses
        render json: Success.new(
                   course: Sku.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         during: sku.course_during,
                         price: sku.selling_price.to_i
                     }
                   }
               )
      end

      def cards

      end


      def create
        #Order.transaction do

        #end
      end

      private
      def face_to_face_params
        params.permit(:sku, :name, :mobile, :amount, :pay_amount, :giveaway)
      end
    end
  end
end