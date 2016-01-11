module Business
  module Schedules
    class CoursesController < BaseController
      def mine
        render json: Success.new(
                   course: Sku.course.online.where(seller_id: @coach.id).order(id: :desc).map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         during: sku.product.prop.during,
                         price: sku.selling_price.floor
                     }
                   }
               )
      end

      def student
        cards = MembershipCard.course.joins(:order)
                    .where(orders: {coach_id: @coach.id, status: Order::STATUS[:pay]})
                    .where('value > 0')
        group_cards =cards.group_by { |card| card.member_id }
        render json: Success.new(
                   course: group_cards.map { |member_id, group_items|
                     mx_user_profile = Profile.find_by(user_id: Member.find(member_id).user_id)
                     {
                         student: {
                             mxid: mx_user_profile.mxid,
                             name: mx_user_profile.name,
                             avatar: mx_user_profile.avatar.url,
                         },
                         course: {
                             count: group_items.size,
                             item: group_items.map { |item|
                               {
                                   id: item.order.order_item.sku,
                                   name: item.name,
                                   type: item.value,
                                   cover: item.order.order_item.cover,
                                   during: item.order.order_item.during,
                                   available: item.value,
                                   used: 0
                               }
                             }
                         }
                     }
                   }
               )
      end
    end
  end
end