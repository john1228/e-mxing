module Business
  module MembershipCards
    class HomeController < BaseController
      def index
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
      end

      def show
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
                       service: course.service.profile.service,
                       store: course.store,
                       limit: course.limit
                   }
               )
      end
    end
  end
end