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
                   records: lesson.appointments.map { |appointment|
                     {
                       id: 'L%08d' + appointment.id,
                       created: appointment.created_at
                     }
                   }
               )
      end
    end
  end
end