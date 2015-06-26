module Mine
  class LessonsController < BaseController
    def index
      case params[:list] #全部
        when 'all'
          render json: Success.new(
                     lessons: @user.appointments.joins(:course).page(params[:page]||1)
                 )
        when 'waiting'
          render json: Success.new(
                     lessons: @user.appointments.joins(:course).where(status: Appointment::STATUS[:waiting]).page(params[:page]||1)
                 )
        else
          render json: Failure.new('未知到数据类型')
      end
    end

    def confirm
      appointment = @user.appointments.find_by(id: params[:id])
      if appointment.update(status: Appointment::STATUS[:done])
        render json: Success.new
      else
        render json: Failure.new(appointment.errors.map { |k, v| "#{k}:#{v}" })
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
  end
end
