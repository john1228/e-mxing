module Business
  class AppointmentsController < BaseController
    def index
      case params[:list]
        when 'all'
          render json: Success.new(appointments: @coach.appointments.order(id: :desc).page(params[:page]||1).collect { |appointment| appointment.as_json('coach') })
        when 'waiting'
          render json: Success.new(appointments: @coach.appointments.where(status: Appointment::STATUS[:waiting]).order(id: :desc).page(params[:page]||1).collect { |appointment| appointment.as_json('coach') })
        else
          render json: Success.new(appoinments: [])
      end
    end

    def create
      #begin
      user = User.find_by_mxid(params[:user])
      lesson = user.lessons.find_by(id: params[:lesson], coach: @coach)
      remain = lesson.available - lesson.used
      amount = params[:amount].to_i
      if remain>= amount
        appointment = Appointment.new(user: user, coach: @coach, lesson: lesson, course: lesson.course, amount: params[:amount])
        if appointment.save
          render json: Success.new
        else
          render json: Failure.new(appointment.errors.map { |k, v| "#{k}:#{v}" })
        end
      else
        render json: Failure.new('该学员剩余到课程不足')
      end
      # rescue Exception => exp
      #   render json: Failure.new(exp.message)
      # end
    end
  end
end