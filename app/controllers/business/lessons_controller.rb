module Business
  class LessonsController < BaseController
    def index
      lesson_ids = @coach.appointments.pluck(:lesson_id) + @coach.lessons.pluck(:id)
      render json: Success.new(
                 lessons: Lesson.where(id: lesson_ids).page(params[:page]||1)
             )
    end

    def records
      lesson = @coach.lessons.find_by(id: params[:id])
      if lesson.blank?
        render json: Failure.new('您没有这个课程')
      else
        render json: Success.new(
                   records: lesson.appointments
               )
      end
    end


    def show
      lesson = Lesson.where('? = ANY (code)', params[:code]).take
      render json: Success.new(lesson: lesson)
    end

    def update
      begin
        lesson = Lesson.where('? = ANY (code)', params[:code]).take
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
            render json: Failure.new('消课失败:' +appointment.errors.full_messages.join(';'))
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
              render json: Failure.new('消课失败:' +appointment.errors.full_messages.join(';'))
            end
          else
            render json: Failure.new('您没有权限消除该课时')
          end
        end
      rescue Exception => exp
        render json: Failure.new('消课失败:' + exp.message)
      end
    end
  end
end