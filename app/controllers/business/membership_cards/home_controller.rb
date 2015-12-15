module Business
  module MembershipCards
    class HomeController < BaseController
      def index
        render json: Success.new(
                   card: MembershipCard.where(card_id: @coach.service.card_types.pluck(:id)).order(id: :desc).map { |card|
                     {

                     }
                   }
               )
      end
    end
  end
end