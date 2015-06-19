module Business
  class AppointmentsController < BaseController
    def index
      render json: Success.new(
                 setting: @coach.appointment_settings.effect(params[:date]||Date.today),
                 appointment: @coach.appointments.where(date: params[:date]||Date.today).group(:start_time).count.map { |k, v|
                   appointed = @coach.appointments.find_by(date: params[:date]||Date.today, start_time: k)
                   {
                       start: k,
                       course: appointed.course_name,
                       classes: appointed.classes,
                       during: appointed.course_during,
                       venues: appointed.venues,
                       address: appointed.address,
                       booked: v
                   }
                 }
             )
    end

    def create
      #预约的课程
      begin
        base_params = appointment_params
        course = @coach.courses.find_by(id: params[:course])
        address = @coach.addresses.find_by(id: params[:address])
        base_params = base_params.merge({
                                            start_time: params[:start],
                                            course_id: course.id,
                                            course_name: course.name,
                                            course_during: course.during,
                                            venues: address.venues,
                                            address: address.city + address.address
                                        })
        if params[:online].present?
          params[:online].split(',').map { |user|
            user = User.find_by_mxid(user)
            lesson = @coach.lessons.find_by(course: course, user: user)
            @coach.appointments.create(base_params.merge(user_id: user.id, lesson_id: lesson.id))
          }
          render json: {code: 1}
        else
          if params[:offline].present?
            @coach.appointments.create(base_params.merge(offline: params[:offline]))
            render json: {code: 1}
          else
            render json: Failure.new('您还未选择学员')
          end
        end
      rescue Exception => e
        render json: {code: 0, message: e.message}
      end
    end

    def show
      begin
        appointments = @coach.appointments.where(date: params[:date], start_time: params[:time])
        if appointments.blank?
          render json: Success.new(booked: {online: [], offline: []})
        else
          render json: Success.new(
                     booked: {
                         online: User.where(id: appointments.pluck(:user_id)).map { |user| user.profile.summary_json },
                         offline: appointments.where.not(offline: nil).pluck(:offline).join(',').split(',').map { |item|
                           offline_info = item.split('|')
                           {
                               name: offline_info[0],
                               phone: offline_info[1]
                           }
                         }
                     }
                 )
        end
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