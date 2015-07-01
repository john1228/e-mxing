module Business
  class CoursesController < BaseController
    def index
      if params[:page].to_i.eql?(1)
        render json: Success.new(
                   top: @coach.courses.top||{},
                   hot: @coach.courses.hot||{},
                   courses: @coach.courses.where.not(status:: Course::STATUS[:delete],id: [(@coach.courses.top.id rescue 0), (@coach.courses.hot.id rescue 0)]).order(id: :desc).page(params[:page]||1)
               )
      else
        render json: Success.new(
                   courses: @coach.courses.where.not(status:: Course::STATUS[:delete],id: [(@coach.courses.top.id rescue 0), (@coach.courses.hot.id rescue 0)]).order(id: :desc).page(params[:page]||1)
               )
      end
    end


    def create
      begin
        course = @coach.courses.new(new_params.merge(status: Course::STATUS[:online]))
        (0..8).each { |index| course.course_photos.build(photo: params[index.to_s.to_sym]) if params[index.to_s.to_sym].present? }
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
      if course.update(update_params)
        render json: Success.new
      else
        render json: Failure.new('更新课程失败')
      end
    end

    def destroy
      course = @coach.courses.find_by(id: params[:id])
      if course.update(status: Course::STATUS[:delete])
        render json: Success.new
      else
        render json: Failure.new('删除课程失败')
      end
    end

    private
    def new_params
      permit_params = params.permit(:name, :type, :style, :during, :price, :exp, :proposal, :intro, :guarantee,
                                    :customized, :top)
      permit_params = permit_params.merge(custom_mxid: params[:mxid], custom_mobile: params[:mobile])
      permit_params.merge(address: params[:address].split(',').map { |item| item.to_i })
    end

    def update_params
      permit_params = params.permit(:price, :exp, :proposal, :intro)
      permit_params.merge(address: params[:address].split(',').map { |item| item.to_i })
    end
  end
end