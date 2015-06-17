module Business
  class StudentsController < BaseController
    #获取学员课程
    def course
      render json: Success.new(
                 courses: @coach.courses.map { |course|
                   {
                       id: course.id,
                       name: course.name,
                       type: course.type
                   }
                 },
                 sold: @coach.lessons.joins(:course).map { |lesson|
                   {
                       id: lesson.course.id,
                       name: lesson.course.name,
                       type: lesson.course.type
                   }
                 }
             )
    end

    #获取线上学员列表
    def index
      render json: Success.new(
                 students: @coach.lessons.select('distinct user_id').where('available > used and exp > ?', Date.today).map { |lesson|
                   user = lesson.user
                   {
                       user: user.profile.summary_json,
                       courses: user.lessons.select('distinct course_id').map { |user_lesson|
                         course = user_lesson.course
                         {
                             id: course.id,
                             name: course.name,
                             type: course.type
                         }
                       }
                   }
                 }
             )
    end
  end
end