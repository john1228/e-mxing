module Business
  class LessonsController < BaseController
    def index
      render json: Success.new(
                 lessons: @coach.lessons.page(params[:page]||1)
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

    def update
      lesson =
      appointment = @coach.appointments.new(code: params[:code])
      if appointment.save
        render json: Success.new
      else
        render json: Failure.new('消课失败:' + appointment.errors.full_messages.join(';'))
      end
    end
  end
end