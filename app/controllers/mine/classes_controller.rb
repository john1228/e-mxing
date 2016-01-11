module Mine
  class ClassesController < BaseController
    def index
      case params[:type]
        when 'incomplete'
          render json: Success.new(classes: MembershipCard.course.where(member: @me.members).where('supply_value > 0').order(id: :desc).page(params[:page]||1).map { |membership_card|
                                     seller_user = User.find_by(id: membership_card.order.seller_id)
                                     {
                                         id: membership_card.id,
                                         course: membership_card.order.order_item.name,
                                         student: @me.profile.name,
                                         seller: seller_user.profile.name,
                                         available: membership_card.supply_value,
                                         used: []
                                     }
                                   })
        when 'complete'
          render json: Success.new(classes: MembershipCardLog.checkin.confirm.includes(:membership_card)
                                                .where(membership_cards: {member_id: @me.members.pluck(:id), card_type: 3})
                                                .order(updated_at: :desc).page(params[:page]||1).map { |log|
                                     seller_user = (User.find_by(id: log.membership_card.order.seller_id) rescue nil)
                                     {
                                         id: log.created_at.strftime('%Y%m%d')+'%05d' % log.id,
                                         course: log.membership_card.name,
                                         seller: seller_user.present? ? seller_user.profile.name : log.membership_card.service.profile.name,
                                         amount: log.change_amount,
                                         status: 1,
                                         created: log.updated_at.localtime.strftime('%Y-%m-%d %H:%M')
                                     }

                                   }
                 )
        else
          render Success.new(classes: [])
      end
    end

    def show
      case params[:type]
        when 'incomplete'
          membership_card = MembershipCard.find_by(id: params[:id])
          seller = (membership_card.order.seller rescue membership_card.service)
          render json: Success.new(class: {
                                       id: membership_card.id,
                                       course: membership_card.name,
                                       seller: seller.profile.name,
                                       seller_type: seller.profile.identity,
                                       available: membership_card.supply_value,
                                       used: [],
                                       during: membership_card.order.order_item.during,
                                       exp: (membership_card.open.next_day(membership_card.valid_days||0) rescue Date.today.next_day(membership_card.valid_days||0)),
                                       class_time: {},
                                       address: [{
                                                     seller: seller.profile.name,
                                                     address: membership_card.order.order_item.course.address,
                                                     tel: membership_card.order.order_item.course.service.profile.mobile,
                                                     coordinate: {
                                                         lng: membership_card.order.order_item.course.coordinate.x,
                                                         lat: membership_card.order.order_item.course.coordinate.y
                                                     }
                                                 }],
                                       qr_code: MembershipCard.general_class_code(membership_card)
                                   })
        else
          render json: Failure.new('无效到请求')
      end
    end

    def comment
      appointment = Appointment.find_by(id: params[:id][8, params[:id].length], status: Appointment::STATUS[:confirm])
      image = []
      (0..8).map { |index| image<< params[index.to_s.to_sym] unless params[index.to_s.to_sym].blank? }
      comment = Comment.new(comment_params.merge(sku: appointment.sku, user: @me, image: image))
      if comment.save
        appointment.update(status: Appointment::STATUS[:finish])
        render json: Success.new
      else
        render json: Failure.new('评论失败' + comment.errors.full_messages.join(';'))
      end
    end

    private
    def comment_params
      params.permit(:content, :score)
    end
  end
end
