module Business
  module Students
    class CoursesController < BaseController
      def index
        user = User.find_by_mxid(params[:mxid])
        if user.blank?
          render json: Failure.new('您查看到用户不存在')
        else
          render json: Success.new(
                     courses: @coach.lessons.where('lessons.available > lessons.used and lessons.user_id = ?', user.id).order(exp: :asc).map { |lesson|
                       {
                           id: lesson.id,
                           course: lesson.course.course_name,
                           cover: lesson.course.course_cover,
                           during: lesson.course.course_during,
                           available: lesson.available,
                           used: lesson.used
                       }
                     }
                 )
        end
      end
    end
  end
end