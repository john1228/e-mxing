module Business
  class AppointmentsController < BaseController
    def index
      render json: Success.new(
                 setting: @coach.appointment_settings.effect(params[:date]),
                 appointment: @coach.appointments.where(date: params[:date]).group(:start_time).count.map { |k, v|
                   appointed = @coach.appointments.find_by(date: params[:date], start_time: k)
                   {
                       start: k,
                       course: appointed.course_name,
                       classes: appointed.classes,
                       during: appointed.course_during,
                       venues: appointed.venues,
                       address: appointed.address,
                       status: appointed.status,
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
          appointment_result = true
          params[:online].split(',').map { |user|
            user = User.find_by_mxid(user)
            lesson = @coach.lessons.find_by(course: course, user: user)
            appointment = @coach.appointments.create(base_params.merge(user_id: user.id, lesson_id: lesson.id))
            appointment_result = false unless appointment.save
          }
          if appointment_result
            render json: Success.new
          else
            render json: Failure.new('该时间已经被预约')
          end
        else
          if params[:offline].present?
            appointment = @coach.appointments.new(base_params.merge(offline: params[:offline]))
            if appointment.save
              render json: Success.new
            else
              render json: Failure.new('该时间已经被预约')
            end
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


    def cancel
      appointment = @coach.appointments.find_by(date: params[:date], start_time: params[:start])
      if appointment.blank?
        render json: Failure.new('该时间段还没有预约，无须取消')
      else
        if appointment.course.style.eql?(Course::STYLE[:many])
          render json: Failure.new('已约团操，不能取消')
        else
          appointment.destroy
          render json: Success.new
        end
      end
    end

    def rest
      appointment = @coach.appointments.find_by(date: params[:date], start_time: params[:start])
      if appointment.present?
        render json: Failure.new('用户已经预约,不能休息')
      else
        @coach.appointments.create(
            date: params[:date],
            start_time: params[:start],
            classes: 1,
            course_during: ((Time.parse(params[:end], Date.parse(params[:date]))-Time.parse(params[:start], Date.parse(params[:date])))/60).to_i.to_s,
            status: Appointment::STATUS[:rest]
        )
        render json: Success.new
      end
    end

    def cancel_rest
      appointment = @coach.appointments.find_by(date: params[:date], start_time: params[:start])
      if appointment.present?
        appointment.update(status: Appointment::STATUS[:waiting])
        render json: Success.new
      else
        render json: Failure.new('该时间段你还没有休息，无须取消')
      end
    end

    private
    def appointment_params
      params.permit(:date, :classes, :offline)
    end

    def verify_password
      user = User.find_by(mobile: params[:username])
      if user.nil?
        render json: {
                   code: 0,
                   message: '该用户还未注册'
               }
      else
        my_password = Digest::MD5.hexdigest("#{params[:password]}|#{user.salt}")
        if user.password.eql?(my_password)
          Rails.cache.write(user.token, user)
          @user = user
        else
          render json: {
                     code: 0,
                     message: '您输入的密码不正确'
                 }
        end
      end
    end

    def verify_sns
      @user = User.find_by(sns: "#{params[:sns_name]}_#{params[:sns_id]}")
      if @user.nil?
        if params[:sns_name].eql?('weixin')
          avatar_array = params[:avatar].split('/')
          avatar_array.last
        end
        @user = User.create(
            sns: "#{params[:sns_name]}_#{params[:sns_id]}",
            name: params[:name],
            avatar: params[:avatar],
            gender: params[:gender],
            birthday: params[:birthday]
        )
      end
      Rails.cache.write(@user.token, @user)
    end
  end
end