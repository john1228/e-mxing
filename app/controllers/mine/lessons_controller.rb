module Mine
  class LessonsController < BaseController
    def index
      case params[:list] #全部
        when 'all'
          render json: Success.new(
                     lessons: @user.appointments.joins(:course).page(params[:page]||1).collect { |appointment| appointment.as_json('coach') }
                 )
        when 'waiting'
          render json: Success.new(
                     lessons: @user.appointments.joins(:course).where(status: Appointment::STATUS[:waiting]).page(params[:page]||1).collect { |appointment| appointment.as_json('coach') }
                 )
        else
          render json: Failure.new(lessons: [])
      end
    end

    def confirm
      appointment = @user.appointments.find_by(id: params[:id], status: Appointment::STATUS[:waiting])
      if appointment.update(status: Appointment::STATUS[:confirm])
        render json: Success.new
      else
        render json: Failure.new(appointment.errors.map { |k, v| "#{k}:#{v}" })
      end
    end

    def comment
      appointment = Appointment.find_by(id: params[:id], status: Appointment::STATUS[:confirm])
      if appointment.blank?
        render json: Failure.new('未确认课时，不能评论')
      else
        course = appointment.course
        comment = Comment.new(comment_params.merge(course: course, user: @user))
        (0..8).map { |index| comment.comment_images.build(image: params[index.to_s.to_sym]) unless params[index.to_s.to_sym].blank? }
        if comment.save
          appointment.update(status: Appointment::STATUS[:finish])
          render json: Success.new
        else
          render json: Failure.new('评论失败')
        end
      end
    end

    def destroy
      appointment = Appointment.find_by(id: params[:id], status: Appointment::STATUS[:waiting])
      if appointment.update(status: Appointment::STATUS[:cancel])
        render json: Success.new
      else
        render json: Failure.new(appointment.errors.map { |k, v| "#{k}:#{v}" })
      end
    end

    private
    def comment_params
      params.permit(:content, :prof, :comm, :punc, :space)
    end
  end
end
