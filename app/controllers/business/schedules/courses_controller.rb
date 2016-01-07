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
        orders = Order.Or
        # {
        #     student: {
        #         mxid: profile.mxid,
        #         name: profile.name,
        #         avatar: profile.avatar.url
        #     },
        #     course: {
        #         count: lessons.size,
        #         item: lessons.map { |lesson|
        #           {
        #               id: lesson.course.id,
        #               name: lesson.course.course_name,
        #               cover: lesson.course.course_cover,
        #               during: lesson.course.course_during,
        #               available: lesson.available,
        #               used: lesson.used
        #           }
        #         }
        #     }
        # }
        render json: Success.new(
                   course: Lesson.classification_of_student(@coach)
               )
      end
    end
  end
end