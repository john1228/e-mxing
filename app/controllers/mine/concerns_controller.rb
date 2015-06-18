module Mine
  class ConcernsController < BaseController
    def index
      concerned_courses = @user.concerneds.includes(:course).where(courses: {status: 1}).page(params[:page]||1)
      render json: Success.new(
                 concerned: concerned_courses.map { |concerned_course|
                   course = concerned_course.course
                   {
                       id: course.id,
                       name: course.name,
                       cover: course.course_photos.first.present? ? course.course_photos.first.photo.thumb.url : '',
                       price: course.price,
                       during: course.during,
                       type: course.type,
                       concerned: course.concerned.count,
                       top: course.top||0
                   } }
             )
    end

    def create
      course = Course.find_by(id: params[:course])
      if course.present?
        concerned = @user.concerneds.new(course: course)
        if concerned.save
          render json: Success.new
        else
          render json: Failure.new('关注课程失败')
        end
      else
        render json: Failure.new('课程不存在')
      end

    end

    def destroy
      concerned = @user.concerneds.find_by(course_d: params[:course])
      if concerned.destroy
        render json: Success.new
      else
        render json: Failure.new('取消关注失败')
      end
    end
  end
end
