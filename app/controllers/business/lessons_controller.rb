module Business
  class LessonsController < BaseController
    def index
      render json: Success.new(
                 lessons: MembershipCardLog.joins(:membership_card).checkin.confirm.where(membership_cards: {order_id: @coach.orders.pay.pluck(:id), card_type: 3}).order(updated_at: :desc).page(params[:page]||1).map { |log|
                   {
                       id: log.created_at.localtime.strftime('%Y%m%d')+'%05d' % log.id,
                       course: log.membership_card.name,
                       student: log.membership_card.member.name,
                       seller: @coach.profile.name,
                       amount: log.change_amount,
                       status: 1,
                       created: log.created_at.localtime.strftime('%Y-%m-%d %H:%M')
                   }
                 }
             )
    end


    def show
      membership_card = MembershipCard.find_by_class_code(params[:code])
      render json: Success.new(lesson: {
                                   id: membership_card.id,
                                   course: membership_card.name,
                                   student: membership_card.member.name,
                                   seller: @coach.profile.name,
                                   available: membership_card.supply_value,
                                   used: []
                               })
    end

    def update
      membership_card = MembershipCard.find_by_class_code(params[:code])
      if membership_card.blank?
        render json: Failure.new('无效的消课码')
      else
        if membership_card.disable?
          render json: Failure.new('该卡已停用')
        else
          if membership_card.order.coach.eql?(@coach)
            if membership_card.valid_end.eql?('已过期')
              render json: Failure.new('该会员卡已过期')
            else
              if membership_card.course?
                if membership_card.supply_value <= 0
                  render json: Failure.new('卡余额不足')
                else
                  checkin_log = membership_card.logs.checkin.pending.create(
                      membership_card_id: membership_card.id,
                      change_amount: 1,
                      service_id: @coach.service.id,
                      remark: '私教消课-消课码-'+ params[:code],
                      operator: @coach.profile.name
                  )
                  if checkin_log.may_confirm?
                    checkin_log.confirm!
                    render json: Success.new
                  else
                    render json: Failure.new('消课失败:课程节数不足')
                  end
                end
              else
                if membership_card.value < 0
                  render json: Failure.new('卡余额不足')
                else
                  checkin_log = membership_card.logs.checkin.pending.create(
                      membership_card_id: membership_card.id,
                      change_amount: 1,
                      service_id: @coach.service.id,
                      remark: '私教消课-消课码-'+ params[:code],
                      operator: @coach.profile.name
                  )
                  if checkin_log.may_confirm?
                    checkin_log.confirm!
                    render json: Success.new
                  else
                    render json: Failure.new('消课失败:课程节数不足')
                  end
                end
              end
            end
          else
            render json: Failure.new('您无权消课')
          end
        end
      end
    end
  end
end