module Business
  class CoursesController < BaseController
    def index
      render json: Success.new(
                 courses: Sku.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |sku|
                   {
                       id: sku.id,
                       name: sku.course_name,
                       type: sku.course_type,
                       style: sku.course.style,
                       during: sku.course.during,
                       price: sku.selling_price,
                       exp: sku.course.exp,
                       proposal: sku.course.proposal,
                       intro: sku.course.intro,
                       guarantee: sku.course_guarantee,
                       address: sku.address,
                       images: sku.course.image.map { |image| image.thumb.url },
                       purchased: sku.orders_count,
                       concerns: sku.concerns_count
                   }
                 })
    end


    def create
      image = []
      (0..8).each { |index| image << params[index.to_s.to_sym] if params[index.to_s.to_sym].present? }
      course = ServiceCourse.new(new_params.merge(agency: @coach.service.id, coach: @coach.id, status: Course::STATUS[:online], image: image))
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
      course = Sku.find_by(id: params[:id])
      if course.update(status: 0)
        render json: Success.new
      else
        render json: Failure.new('删除课程失败')
      end
    end

    private
    def new_params
      permit_params = params.permit(:name, :type, :style, :during, :exp, :proposal, :intro, :guarantee)
      permit_params.merge(price: params[:price])
    end

    def update_params
      permit_params = params.permit(:price, :exp, :proposal, :intro)
      permit_params.merge(address: params[:address].split(',').map { |item| item.to_i })
    end
  end
end