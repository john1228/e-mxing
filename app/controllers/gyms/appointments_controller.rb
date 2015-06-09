module Gyms
  class AppointmentsController < BaseController
    #预约概况
    def index
      render json: Success.new({full: @coach.expiries.where(date: Date.today..Date.today.next_month(1)).pluck(:date)})
    end

    #天预约详情
    def day
      render json: Success.new({
                                   setting: @coach.appointment_settings.effect(params[:date]||Date.today),
                                   appointment: @coach.appointments.where(date: params[:date]||Date.today).collect { |appointment| appointment.as_json }
                               })
    end
  end
end
