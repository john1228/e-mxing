module Gyms
  class AppointmentsController < BaseController
    #预约概况
    def index
      if params[:date].blank?
        render json: Success.new({full: @coach.expiries.where(date: Date.today..Date.today.next_month(1)).pluck(:date)})
      else
        render json: Success.new({
                                     setting: @coach.appointment_settings.effect(params[:date]||Date.today),
                                     appointment: @coach.appointments.where(date: params[:date]||Date.today).collect { |appointment| appointment.as_json }
                                 })
      end

    end


    def confirm

    end

    def comment

    end
  end
end
