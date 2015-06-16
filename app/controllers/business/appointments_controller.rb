module Business
  class AppointmentsController < BaseController
    def index
      render json: Success.new(
                 setting: @coach.appointment_settings.effect(params[:date]||Date.today),
                 appointment: @coach.appointments.where(date: params[:date]||Date.today)
             )
    end

    def create
      #预约的课程
      #begin
      @coach.appointments.create(appointment_params)
      render json: {code: 1}
      #rescue Exception => e
      #  render json: {code: 0, message: e.message}
      #end
    end

    def destroy

    end


    private
    def appointment_params
      permit_params = params.permit(:date, :classes, :online, :offline)
      course = @coach.courses.find_by(id: params[:course])
      address = @coach.addresses.find_by(id: params[:address])
      permit_params.merge({
                              lesson_id: @coach.lessons.find_by(course: course).id,
                              start_time: params[:start],
                              course_id: course.id,
                              course_name: course.name,
                              course_during: course.during,
                              venues: address.venues,
                              address: address.city + address.address
                          })

    end
  end
end