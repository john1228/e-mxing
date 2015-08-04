module Business
  class StudentsController < BaseController
    #获取线上学员列表
    def index
      render json: Success.new(
                 students: @coach.lessons.select('DISTINCT(user_id) user_id').where('available > used').page(params[:page]||1).map { |lesson|
                   latest_lesson = Lesson.where(user_id: lesson.user_id).order(id: :desc).take
                   lesson.user.profile.summary_json.merge(contact: latest_lesson.contact_phone)
                 }
             )
    end

    def courses
      user = User.find_by_mxid(params[:student])
      if user.blank?
        render json: Failure.new('您查看到用户不存在')
      else
        render json: Success.new(
                   courses: @coach.lessons.joins(:course).where('lessons.available > lessons.used and lessons.user_id = ?', user.id).order(exp: :asc).map { |lesson|
                     {
                         name: lesson.course.name,
                         available: lesson.available,
                         used: lesson.used
                     }
                   }
               )
      end

    end

    def attend
      user = User.find_by_mxid(params[:student])
      if user.blank?
        render json: Failure.new('您查看到用户不存在')
      else
        render json: Success.new
      end
    end
  end
end