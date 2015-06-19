module Business
  class CoursesController < BaseController
    def index
      type = params[:type]
      case type
        when 'one'
          courses = @coach.courses.where(style: Course::STYLE[:one])
        when 'many'
          courses = @coach.courses.where(style: Course::STYLE[:many])
        else
          courses = @coach.courses.page(params[:page]||1)
      end
      render json: Success.new(courses: courses.collect { |item|
                                 {
                                     id: item.id,
                                     name: item.name,
                                     type: item.type,
                                     style: item.style,
                                     during: item.during,
                                     price: item.price,
                                     exp: item.exp,
                                     proposal: item.proposal,
                                     intro: item.intro,
                                     address: item.school_addresses,
                                     guarantee: item.guarantee,
                                     top: item.top,
                                     images: item.course_photos.collect { |course_photo| course_photo.photo.thumb.url },
                                 }
                               })
    end


    def create
      begin
        course = @coach.courses.new(new_params)
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
      permit_params = params.permit(:name, :type, :style, :during, :price, :exp, :proposal, :intro,
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