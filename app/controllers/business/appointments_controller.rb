module Business
  class AppointmentsController < BaseController
    def index
      render json: {
                 code: 1,
                 data: {
                     #设置
                     setting: @coach.appointment_settings.effect(params[:date]||Date.today),
                     #已约
                     appointment: @coach.appointments.where(date: params[:date]||Date.today)}.collect { |appointment| appointment.as_json
                 }
             }
    end

    def create
      #预约的课程
      begin
        logger.info appointment_params
        @coach.appointments.create(appointment_params)
        render json: {code: 1}
      rescue Exception => e
        render json: {code: 0, message: e.message}
      end
    end

    private
    def appointment_params
      permit_params = params.permit(:date, :classes, :online, :offline)
      course = @coach.courses.find_by(id: params[:course])
      address = @coach.addresses.find_by(id: params[:address])
      permit_params.merge({
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