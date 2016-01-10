module Business
  class LessonsController < BaseController
    def index
      render json: Success.new(
                 lessons: MembershipCardLog.joins(:membership_card).checkin.confirm.where(membership_cards: {order_id: @coach.orders.pay.pluck(:id)}).order(updated_at: :desc).page(params[:page]||1).map { |log|
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
      lesson = Lesson.where('? = ANY (code)', params[:code]).take
      render json: Success.new(lesson: lesson)
    end

    def update
      begin
        membership_card_id = params[:code].index(Time.now.to_i.to_s.length, params[:code].length-2-Time.now.to_i.to_s.length)
        lesson = Lesson.where('? = ANY (code)', params[:code].upcase).take
        if lesson.present?
          sku = Sku.find_by(sku: lesson.sku)
          if sku.seller_id.eql?(@coach.id)
            appointment = @coach.appointments.new(
                lesson_id: lesson.id, user_id: lesson.user_id,
                sku: lesson.sku, code: params[:code], amount: 1,
                status: Appointment::STATUS[:confirm]
            )
            if appointment.save
              render json: Success.new
            else
              render json: Failure.new('消课失败')
            end
          else
            service = Service.find_by(id: sku.seller_id)
            if service.present? && service.coaches.include?(@coach)
              appointment = @coach.appointments.new(
                  lesson_id: lesson.id, user_id: lesson.user_id,
                  sku: lesson.sku, code: params[:code], amount: 1,
                  status: Appointment::STATUS[:confirm]
              )
              if appointment.save
                render json: Success.new
              else
                render json: Failure.new('消课失败')
              end
            else
              render json: Failure.new('您没有权限消除该课时')
            end
          end
        else
          render json: Failure.new('无效到课程码')
        end
      rescue Exception => exp
        render json: Failure.new('消课失败')
      end
    end
  end
end