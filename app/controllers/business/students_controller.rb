module Business
  class StudentsController < BaseController
    def index
      render json: Success.new(students: @coach.lessons.join(:user, :course).available.map { |lesson|
                                 {
                                     user: lesson.user.profile.summary_json,
                                     course: {
                                         id: lesson.course.id,
                                         name: lesson.course.name
                                     }
                                 }
                               })
    end
  end
end