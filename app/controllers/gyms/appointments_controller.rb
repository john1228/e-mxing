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
                                     appointment: @coach.appointments.where(date: params[:date]||Date.today).group(:start_time).count.each { |k, v|
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
                                 })
      end
    end

    #团操预约
    def appoint
      begin
        coach = Coach.find_by_mxid(params[:mxid])
        setting = coach.appointment_settings.set_of_many(params[:date], params[:time])
        if setting.blank?
          render json: Failure.new('教练还未设置该时间段预约')
        else
          course_name = setting.course_name
          course = coach.courses.find_by(name: course_name)
          user_lesson = @user.lessons.where('available > used and exp< ? and course_id=?', Date.today, course.id).take
          if user_lesson.present?
            address = setting.address
            @user.appointments.create(
                coach_id: coach.id,
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
            render json: Failure.new('01', '您还没有购买该课程或者您购买到课程已过期')
          end
        end
      rescue Exception => e
        render json: Failure.new(e.message)
      end
    end

    def show
      begin
        coach = Coach.find_by_mxid(params[:mxid])
        appointments = coach.appointments.where(date: params[:date], start_time: params[:time])
        if appointments.blank?
          render json: Success.new(booked: [])
        else
          render json: Success.new(
                     booked: User.where(id: appointments.pluck(:user_id)).map { |user| user.profile.summary_json }
                 )
        end
      rescue Exception => e
        render json: Failure.new(e.message)
      end
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
