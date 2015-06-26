module Business
  class StudentsController < BaseController
    #获取线上学员列表
    def index
      render json: Success.new(
                 students: @coach.lessons.select('DISTINCT(user_id) user_id').where('available > used').page(params[:page]||1).map { |lesson|
                   lesson.user.profile.summary_json
                 }
             )
    end

    def courses
      user = User.find_by_mxid(params[:student])
      render json: Success.new(
                 courses: @coach.lessons.joins(:courses).where(user: user) { |lesson|
                   {
                       id: lesson.course.id,
                       name: lesson.course.name,
                       cover: (lesson.course.course_photos.first.thumb.url rescue ''),
                       type: lesson.course.type,
                       style: lesson.course.style,
                       during: lesson.course.during
                   }
                 }
             )
    end
  end
end