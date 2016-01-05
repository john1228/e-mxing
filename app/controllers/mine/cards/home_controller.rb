module Mine
  module Cards
    class HomeController < BaseController
      def index
        if params[:type].eql?('expired')
          cards = @me.cards.find_all { |card| card.valid_end.eql?('已过期') }
        else
          cards = @me.cards
        end

        render json: Success.new(
                   cards: cards.order(id: :desc).map { |card|
                     {
                         id: card.id,
                         name: card.name,
                         card_type: card.card_type,
                         value: card.value,
                         valid_end: card.valid_end,
                         member: {
                             name: card.member.name,
                             avatar: card.member.avatar.url
                         },
                         service: {
                             mxid: card.service.profile.mxid,
                             name: card.service.profile.name,
                             avatar: card.service.profile.avatar.url,
                             address: card.service.profile.detail_address,
                             mobile: card.service.profile.mobile
                         }
                     }
                   }
               )
      end

      def service_card
        service = Service.find_by_mxid(params[:mxid])
        cards = @me.cards.where(service: service)
        render json: {
                   cards: cards.order(id: :desc).map { |card|
                     {
                         id: card.id,
                         name: card.name,
                         card_type: card.card_type,
                         value: card.value,
                         valid_end: card.valid_end,
                         member: {
                             name: card.member.name,
                             avatar: card.member.avatar.url
                         },
                         service: {
                             mxid: card.service.profile.mxid,
                             name: card.service.profile.name,
                             avatar: card.service.profile.avatar.url,
                             address: card.service.profile.detail_address,
                             mobile: card.service.profile.mobile
                         }
                     }
                   }
               }
      end
    end
  end
end