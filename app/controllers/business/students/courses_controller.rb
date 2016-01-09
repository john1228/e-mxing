module Business
  module Students
    class CoursesController < BaseController
      def index
        user = User.find_by_mxid(params[:mxid])
        if user.blank?
          render json: Failure.new('您查看到用户不存在')
        else
          render json: Success.new(
                     courses: MembershipCard.includes(:order).where(orders: {coach_id: @coach.id}).where('supply_value > 0').map { |membership_card|
                       {
                           id: membership_card.id,
                           course: membership_card.name,
                           cover: membership_card.order.order_item.cover,
                           during: membership_card.order.order_item.during,
                           available: membership_card.supply_value,
                           used: 0
                       }
                     }
                 )
        end
      end
    end
  end
end