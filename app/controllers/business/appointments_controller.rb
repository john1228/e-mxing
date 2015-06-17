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
      base_params = appointment_params
      course = @coach.courses.find_by(id: params[:course])
      address = @coach.addresses.find_by(id: params[:address])
      base_params = base_params.merge({
                                          lesson_id: @coach.lessons.find_by(course: course).id,
                                          start_time: params[:start],
                                          course_id: course.id,
                                          course_name: course.name,
                                          course_during: course.during,
                                          venues: address.venues,
                                          address: address.city + address.address
                                      })
      params[:online].split(',').map { |user|
        user = User.find_by_mxid(user)
        @coach.appointments.create(base_params.merge(user_id: user.id))
      }
      render json: {code: 1}
      #rescue Exception => e
      #  render json: {code: 0, message: e.message}
      #end
    end

    def destroy

    end


    private
    def appointment_params
      params.permit(:date, :classes, :offline)
    end
  end
end