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
      begin
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
      rescue Exception => e
        render json: {code: 0, message: e.message}
      end
    end

    def show
      begin
        appointments = @coach.appointments.where(date: params[:date], start_time: params[:time])
        appointment_info = appointments.first
        render json: Success.new(
                   appointment: {
                       start: appointment_info.start_time,
                       course: appointment_info.course_name,
                       classes: appointment_info.classes,
                       during: appointment_info.course_during,
                       venues: appointment_info.venues,
                       address: appointment_info.address,
                       booked: User.where(id: appointments.pluck(:user_id)).map { |user| user.profile.summary_json }
                   }
               )
      rescue Exception => e
        render json: Failure.new(e.message)
      end
    end

    def destroy
      setting = @coach.appointment_setting.where(start_date: params[:date])
      if setting.blank?
        #当天未设置，查找之前1v1設置
        setting = @coach.appointment_setting.where.not(course_name: nil).where('start_date < ?', params[:date])
        if setting.blank?
          @coach.appointment_setting.create(start_date: params[:date], time: "9:00|#{params[:start]},#{params[:end]}|21:00", repeat: 0)
        else
          now_setting_times = setting.time.split(',')
          new_setting_times = now_setting_times
          delete_start = Time.parse(params[:start], Date.parse(params[:date]))
          delete_end = Time.parse(params[:end], Date.parse(params[:date]))
          now_setting_times.map { |item|
            setting_time = item.split('|')
            start_hour, end_hour = setting_time[0], setting_time[1]
            start_time, end_time = Time.parse(start_hour, Date.parse(params[:date])), Time.parse(end_hour, Date.parse(params[:date]))
            if start_time<delete_start&&delete_end<end_time
              new_setting_times.delete(item)
              new_setting_times<<"#{start_hour}|#{delete_start}"<<"#{delete_end}|#{end_hour}"
            end
          }
          @coach.appointment_setting.create(start_date: params[:date], time: new_setting_times.join(','), repeat: 0)
        end
      else
        #当天已设置

      end
    end


    private
    def appointment_params
      params.permit(:date, :classes, :offline)
    end
  end
end