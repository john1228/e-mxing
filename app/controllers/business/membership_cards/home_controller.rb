module Business
  module MembershipCards
    class HomeController < BaseController
      def index
        render json: Success.new(
                   course: Sku.online.where.not(course_type: Sku.course_types['course']).where(seller_id: @coach.service.id).order(id: :desc).page(params[:page]||1).map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         price: sku.selling_price.to_i,
                         type: sku.product.card_type.card_type,
                         value: sku.product.card_type.value,
                         valid_days: sku.product.card_type.valid_days||0,
                         delay_days: sku.product.card_type.delay_days||0,
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
                       price: course.selling_price.to_i,
                       score: course.score,
                       type: course.product.card_type.card_type,
                       value: course.product.card_type.value,
                       valid_days: course.product.card_type.valid_days||0,
                       delay_days: course.product.card_type.delay_days||0,
                       intro: course.product.description,
                       special: course.product.special,
                       venue: course.service.profile.name,
                       avatar: course.service.profile.avatar.url,
                       address: course.address,
                       service: course.service.profile.service,
                       store: course.store||-1,
                       limit: course.limit||-1
                   }
               )
      end
    end
  end
end