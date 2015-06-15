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

    def show
      course = params[:course]
      render json: {
             }
    end

    def create

    end

    def confirm
      appointment = Appointment.find_by(id: params[:id])
      if appointment.update(status: Appointment::STATUS[:done])
        render json: Success.new
      else
        render json: Failure.new('确认完成上课失败')
      end
    end

    def comment
      comment = Comment.new(comment_params)
      (0..8).map { |index| comment.comment_images.build(image: params[index.to_s.to_sym]) unless params[index.to_s.to_sym].blank? }
      if comment.save
        render json: Success.new
      else
        render json: Failure.new('评论失败')
      end
    end

    private
    def comment_params
      params.permit(:content, :prof, :comm, :punc, :space)
    end
  end
end
