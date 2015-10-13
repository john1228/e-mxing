module Business
  class CoursesController < BaseController
    def index
      render json: Success.new(
                 courses: @coach.courses.where(status: Course::STATUS[:online]).order(id: :desc).page(params[:page]||1)
             )
    end


    def create
      image = []
      (0..8).each { |index| image << params[index.to_s.to_sym] if params[index.to_s.to_sym].present? }
      course = ServiceCourse.new(new_params.merge(coach: @coach.id, status: Course::STATUS[:online], image: image))
      if course.save
        render json: Success.new
      else
        render json: Failure.new('课程添加失败')
      end
    end

    def update
      course = @coach.courses.find_by(id: params[:id])
      if course.update(update_params)
        render json: Success.new
      else
        render json: Failure.new('更新课程失败')
      end
    end

    def destroy
      course = @coach.courses.find_by(id: params[:id])
      if course.update(status: Course::STATUS[:offline])
        render json: Success.new
      else
        render json: Failure.new('删除课程失败')
      end
    end

    private
    def new_params
      permit_params = params.permit(:name, :type, :style, :during, :price, :exp, :proposal, :intro, :guarantee)
      permit_params.merge(address: params[:address].split(','))
    end

    def update_params
      permit_params = params.permit(:price, :exp, :proposal, :intro)
      permit_params.merge(address: params[:address].split(',').map { |item| item.to_i })
    end
  end
end