module Business
  class CoursesController < BaseController
    def index
      render json: Success.new(courses: @coach.courses)
    end

    def create
      begin
        course = @coach.courses.new(course_params)
        (0..8).each { |index| course.course_photos.new(photo: params[index.to_s.to_sym]) if params[index.to_s.to_sym].present? }
        if course.save
          render json: Success.new
        else
          render json: Failure.new('课程添加失败')
        end
      rescue Exception => e
        render json: Failure.new(e.message)
      end
    end

    def update
      course = @coach.courses.find_by(id: params[:id])
      if course.save
        render json: Success.new
      else
        render json: Failure.new('更新课程失败')
      end
    end

    def destroy

    end

    private
    def course_params
      permit_params = params.permit(:name, :type, :style, :during, :price, :exp, :proposal, :intro,
                                    :address, :customized, :top)
      permit_params.merge(custom_mxid: params[:mxid], custom_mobile: params[:mobile])
    end
  end
end