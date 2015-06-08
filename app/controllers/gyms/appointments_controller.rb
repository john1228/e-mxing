module Gyms
  class AppointmentsController < BaseController
    #预约概况
    def index
      render json: {
                 code: 1,
                 data: {
                     full: @coach.expiries.where(date: Date.today..Date.today.next_month(1)).pluck(:date)
                 }
             }
    end

    #天预约详情
    def day
      date = params[:date]
      render json: {
                 code: 1,
                 data: {
                     data: {
                         #设置
                         setting: @coach.appointment_settings.effect(date||Date.today),
                         #已约
                         appointment: @coach.appointments.where(date: date||Date.today)}.collect { |appointment| appointment.as_json
                     }
                 }
             }
    end
  end
end
