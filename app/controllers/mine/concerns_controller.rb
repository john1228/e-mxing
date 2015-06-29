module Mine
  class ConcernsController < BaseController
    def index
      concerns = @user.concerns.page(params[:page]||1)
      render json: Success.new(
                 concerned: concerns.map { |concern|
                   course = concern.course
                   {
                       id: course.id,
                       name: course.name,
                       cover: course.course_photos.first.present? ? course.course_photos.first.photo.thumb.url : '',
                       price: course.price,
                       during: course.during,
                       type: course.type,
                       style: course.style,
                       concerned: course.concerns_count,
                       top: course.top||0,
                       status: course.status,
                       coach: course.coach.profile.summary_json
                   } }
             )
    end

    def create
      course = Course.find_by(id: params[:course])
      if course.present?
        concerned = @user.concerns.new(course: course)
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
      concerned = @user.concerns.find_by(course_id: params[:course])
      if concerned.destroy
        render json: Success.new
      else
        render json: Failure.new('取消关注失败')
      end
    end
  end
end
