module Mine
  class ClassesController < BaseController
    def index
      case params[:type]
        when 'incomplete'
          render json: Success.new(classes: @user.lessons.joins(:course).where('lessons.available > lessons.used').order(id: :asc))
        when 'complete'
          render json: Success.new(classes: @user.appointments)
        else
          render Success.new(classes: [])
      end
    end

    def show
      case params[:type]
        when 'incomplete'
          render json: Success.new(class: @user.lessons.find_by(id: params[:id]).detail)
        else
          render json: Failure.new('无效到请求')
      end
    end

    def comment
      appointment = Appointment.find_by(id: params[:id][8, params[:id].length], status: Appointment::STATUS[:confirm])
      comment = Comment.new(comment_params.merge(sku: appointment.sku, user: @user))
      (0..8).map { |index| comment.comment_images.build(image: params[index.to_s.to_sym]) unless params[index.to_s.to_sym].blank? }
      if comment.save
        appointment.update(status: Appointment::STATUS[:finish])
        render json: Success.new
      else
        render json: Failure.new('评论失败' + comment.errors.full_messages.join(';'))
      end
    end

    private
    def comment_params
      params.permit(:content, :score)
    end
  end
end
