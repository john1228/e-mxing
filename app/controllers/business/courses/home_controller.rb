module Business
  module Courses
    class HomeController < BaseController
      def index
        case params[:type]
          when 'courses'
            render json: Success.new(
                       course: Sku.course.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |sku|
                         {
                             id: sku.id,
                             name: sku.course_name,
                             cover: sku.course_cover,
                             during: sku.course_during,
                             price: sku.selling_price.to_i
                         }
                       }
                   )
          when 'membership_cards'
            render json: Success.new(
                       course: Sku.card.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |sku|
                         {
                             id: sku.id,
                             name: sku.course_name,
                             cover: sku.course_cover,
                             during: sku.course_during,
                             price: sku.selling_price.to_i
                         }
                       }
                   )
          else
            render json: Failure.new('无效的请求')
        end
      end

      def show
        case params[:type]
          when 'courses'
            course = Sku.course.online.find(params[:id])
            render json: Success.new(
                       course: {
                           id: course.id,
                           name: course.course_name,
                           image: course.course.image.map { |image| image.url },
                           price: course.selling_price.to_i,
                           guarantee: course.course_guarantee,
                           score: course.score,
                           type: course.course_type,
                           style: course.course.style,
                           exp: course.course.exp,
                           during: course.course_during,
                           proposal: course.course.proposal,
                           intro: course.course.intro,
                           special: course.course.special,
                           venue: course.service.profile.name,
                           purchased: course.orders_count,
                           concerns: course.concerns_count,
                           address: course.address,
                           service: course.service.profile.service
                       }
                   )
          when 'membership_cards'
            course = Sku.card.online.find(params[:id])
            render json: Success.new(
                       course: {
                           id: course.id,
                           name: course.course_name,
                           image: course.product.image.map { |image| image.url },
                           price: course.selling_price.to_i,
                           score: course.score,
                           type: course.course_type,
                           style: course.course.style,
                           intro: course.product.intro,
                           special: course.product.special,
                           venue: course.service.profile.name,
                           purchased: course.orders_count,
                           concerns: course.concerns_count,
                           address: course.address,
                           service: course.service.profile.service
                       }
                   )
          else
            render json: Failure.new('无效的请求')
        end


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