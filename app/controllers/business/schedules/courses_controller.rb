module Business
  module Schedules
    class CoursesController < BaseController
      def mine
        render json: Success.new(
                   course: Sku.online.where(seller_id: @coach.id).order(id: :desc).map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         during: sku.product.prop.during,
                         price: sku.selling_price.floor
                     }
                   }
               )
      end

      def student
        render json: Success.new(
                   course: Lesson.classification_of_student(@coach)
               )
      end
    end
  end
end