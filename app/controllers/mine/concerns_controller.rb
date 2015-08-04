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
                       cover: course.cover,
                       price: course.price,
                       during: course.during,
                       type: course.type,
                       style: course.style,
                       guarantee: course.guarantee,
                       concerned: course.concerns_count,
                       coach: course.coach.profile.summary_json
                   } }
             )
    end

    def create
      concerned = @user.concerns.new(course: course)
      if concerned.save
        render json: Success.new
      else
        render json: Failure.new('关注课程失败')
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
