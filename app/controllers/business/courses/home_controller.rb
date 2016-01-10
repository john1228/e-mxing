module Business
  module Courses
    class HomeController < BaseController
      def index
        if params[:type].eql?('general')
          sku_list = Sku.course.online.where(seller_id: @coach.service_id).order(id: :desc).page(params[:page]||1)
        else
          sku_list = Sku.course.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1)
        end
        render json: Success.new(
                   course: sku_list.map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         during: sku.product.prop.during,
                         price: sku.selling_price.floor,
                         concerns: sku.concerns_count
                     }
                   }
               )
      end

      def show
        course = Sku.online.find(params[:id])
        render json: Success.new(
                   course: {
                       id: course.id,
                       name: course.course_name,
                       image: course.product.image.map { |image| image.url },
                       price: course.selling_price.floor,
                       guarantee: 0,
                       score: course.score,
                       type: course.product.card_type.value,
                       style: course.product.prop.style,
                       exp: course.product.card_type.delay_days,
                       during: course.product.prop.during,
                       proposal: course.product.prop.proposal,
                       intro: course.product.description,
                       special: course.product.special,
                       venue: @coach.service.profile.name,
                       purchased: course.orders_count,
                       concerns: course.concerns_count,
                       address: course.address,
                       service: @coach.service.profile.service
                   }
               )
      end


      def create
        image = []
        (0..8).each { |index| image << params[index.to_s.to_sym] if params[index.to_s.to_sym].present? }
        course = ServiceCourse.new(new_params.merge(agency: @coach.service.id, coach: @coach.id, status: Course::STATUS[:online], image: image))
        if course.save
          render json: Success.new
        else
          render json: Failure.new("课程添加失败:#{course.errors.messages.values.join('')}")
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
        sku = Sku.find_by(sku: params[:id])
        if sku.course.offline
          render json: Success.new
        else
          render json: Failure.new('删除课程失败')
        end
      end

      private
      def new_params
        permit_params = params.permit(:name, :type, :style, :during, :exp, :proposal, :intro, :guarantee)
        permit_params.merge(selling_price: params[:price], market_price: params[:price])
      end

      def update_params
        permit_params = params.permit(:price, :exp, :proposal, :intro)
        permit_params.merge(address: params[:address].split(',').map { |item| item.to_i })
      end
    end
  end
end