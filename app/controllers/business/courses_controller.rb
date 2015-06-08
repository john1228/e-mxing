module Business
  class CoursesController < BaseController
    def index
      render json: {code: 1, data: {courses: @coach.courses.collect { |course| course.as_json }}}
    end

    def create
      begin
        course = @coach.courses.new(course_params)
        (0..6).each { |index| course.course_photos.new(photo: params[index.to_s.to_sym]) if params[index.to_s.to_sym].present? }
        if course.save
          render json: {code: 1}
        else
          render json: {code: 0, message: '课程添加失败'}
        end
      rescue Exception => e
        render json: {code: 0, message: e.message}
      end
    end

    def update
      course = @coach.courses.find_by(id: params[:id])
      if course.save
        render json: {code: 1}
      else
        render json: {code: 0, message: '更新课程失败'}
      end
    end

    private
    def course_params
      params.permit(:name, :type, :style, :during, :price, :exp, :proposal, :intro,
                    :address, :customized, :mxid, :mobile, :top)
    end
  end
end