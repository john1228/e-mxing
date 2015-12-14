module Business
  module Courses
    class HomeController < BaseController
      def index
        render json: Success.new(
                   courses: Sku.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |course|
                     {
                         id: course.id,
                         name: course.course_name,
                         cover: course.course_cover,
                         price: course.selling_price,
                         guarantee: course.course_guarantee,
                         concerns: course.concerns_count
                     }
                   })
      end

      def show
        course = Sku.online.find(params[:sku])
        render json: Success.new(
                   course: {
                       id: course.id,
                       name: course.course_name,
                       image: course.image.map { |image| image.url },
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
                       service: course.service.profile.name,
                       purchased: course.orders_count,
                       concerns: course.concerns_count,
                       address: course.address
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