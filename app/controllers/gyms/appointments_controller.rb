module Gyms
  class AppointmentsController < BaseController
    before_action :verify_auth_token, only: [:appoint, :confirm, :comment]
    #预约概况
    def index
      if params[:date].blank?
        render json: Success.new({full: @coach.expiries.where(date: Date.today..Date.today.next_month(1)).pluck(:date)})
      else
        render json: Success.new({
                                     setting: @coach.appointment_settings.effect(params[:date]||Date.today),
                                     appointment: @coach.appointments.where(date: params[:date]||Date.today).group(:start_time).each { |k, v|
                                       appointed = @coach.appointments.find_by(date: params[:date]||Date.today, time: k)
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
                                 })
      end
    end

    #团操预约
    def appoint
      begin
        coach = Coach.find_by_mxid(params[:mxid])
        appointed = coach.appointments.find_by(date: params[:date], time: params[:time])
        if appointed.blank?
          setting = coach.appointment_settings.set_of_many(params[:date], params[:time])
          if setting.blank?
            render json: Failure.new('教练还未设置该时间段预约')
          else
            course_name = setting.course_name
            course = coach.courses.find_by(name: course_name)
            if @user.lessons.is_valid?(course)
              # base_params = {date: params[:date]}
              # classes
              # course = @coach.courses.find_by(id: params[:course])
              # address = @coach.addresses.find_by(id: params[:address])
              # base_params = base_params.merge({
              #                                     lesson_id: @coach.lessons.find_by(course: course).id,
              #                                     start_time: params[:start],
              #                                     course_id: course.id,
              #                                     course_name: course.name,
              #                                     course_during: course.during,
              #                                     venues: address.venues,
              #                                     address: address.city + address.address
              #                                 })
              # params[:online].split(',').map { |user|
              #   user = User.find_by_mxid(user)
              #   @coach.appointments.create(base_params.merge(user_id: user.id))
              # }

              address = setting.address
              coach.appointments.create(
                  date: params[:date],
                  classes: 1,

                  start_time: params[:time],
                  course_id: course.id,
                  course_name: course.name,
                  course_during: course.during,
                  venues: address.venues,
                  address: address.city + address.address
              )
            else
              render json: Failure.new('您还没有购买该课程或者您购买到课程已过期')
            end
          end
        else
        end
      rescue Exception => e
        render json: Failure.new(e.message)
      end
    end

    def confirm
      appointment = @user.appointments.find_by(id: params[:id])
      if appointment.update(status: Appointment::STATUS[:done])
        render json: Success.new
      else
        render json: Failure.new('确认完成上课失败')
      end
    end

    def comment
      # appointment = Appointment.find_by(id: params[:id], status: Appointment::STATUS[:done])
      # if appointment.blank?
      #   render json: Failure.new('未完成到课时，不能评论')
      # else
      course = Course.first
      comment = Comment.new(comment_params.merge(course: course, user: @user))
      (0..8).map { |index| comment.comment_images.build(image: params[index.to_s.to_sym]) unless params[index.to_s.to_sym].blank? }
      if comment.save
        #appointment.update(status: Appointment::STATUS[:complete])
        render json: Success.new
      else
        render json: Failure.new('评论失败')
      end
      #end
    end

    private
    def comment_params
      params.permit(:content, :prof, :comm, :punc, :space)
    end

    def verify_auth_token
      @user = Rails.cache.read(request.headers[:token])
      render json: {code: -1, message: '您还没有登录'} if @user.blank?
    end
  end
end
