module Business
  module Schedules
    class CoursesController < BaseController
      def mine
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

      def student
        students_lesson = Lesson.where(coach_id: @coach.id).where('available > used').group(:user_id).count
        render json: Success.new(
                   course: students_lesson.map { |k, v|
                     user_profile = Profile.find_by(user_id: k)
                     {
                         student: {
                             mxid: user_profile.mxid,
                             name: user_profile.name,
                             avatar: user_profile.avatar.url
                         },
                         course: {
                             count: v,
                             item: Lesson.where(user_id: k).map { |lesson|
                               course = Sku.find(lesson.sku)
                               {
                                   id: course.id,
                                   name: course.course_name,
                                   cover: course.course_cover,
                                   during: course.course_during,
                                   available: lesson.available,
                                   used: lesson.used
                               }
                             }
                         }
                     }
                   }
               )
      end
    end
  end
end