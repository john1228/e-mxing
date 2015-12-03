module Business
  module Students
    class CoursesController < BaseController
      def index
        user = User.find_by_mxid(params[:student])
        if user.blank?
          render json: Failure.new('您查看到用户不存在')
        else
          render json: Success.new(
                     courses: @coach.lessons.where('lessons.available > lessons.used and lessons.user_id = ?', user.id).order(exp: :asc).map { |lesson|
                       {
                           id: lesson.id,
                           course: lesson.course.course_name,
                           student: lesson.user.profile.name,
                           seller: lesson.course.seller,
                           available: lesson.available,
                           used: lesson.appointments.pluck(:code)
                       }
                     }
                 )
        end
      end
    end
  end
end