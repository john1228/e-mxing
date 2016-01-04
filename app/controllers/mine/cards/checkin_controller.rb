module Mine
  class CheckinController < BaseController

    def index
      card = @me.cards.find(params[:id])
      if card.present?
        render json: Success.new(
                   logs: card.logs.check.order(created_at: :desc).map { |log|
                     {
                         created: log.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                         amount: log.change_amount
                     }
                   }
               )
      else
        render json: Failure.new('无效的会员卡号')
      end
    end

    def create
      card = @me.cards.find(params[:id])
      if card.present?
        if card.checkin
          render json: Success.new(
                     card: {
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
                 )
        else
          render json: Failure.new('签到失败:' +@card.errors.messages.values.join(';'))
        end
      else
        render json: Failure.new('无效的会员卡号')
      end
    end
  end
end