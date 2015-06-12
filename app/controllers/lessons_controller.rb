class LessonsController < ApiController
  before_action :verify_auth_token

  def index
    case params[:type] #0-预约课时 1-未约课时 2-过期课时
      when '0'
        render json: Success.new(
                   lessons: @user.appointments.joins(:course).page(params[:page]||1).collect { |appointment| {
                       course: {
                           name: appointment.course_name,
                           type: appointment.course.type,
                           during: appointment.course_during
                       },
                       appointment: {
                           id: appointment.id,
                           date: appointment.date,
                           start: appointment.start,
                           classes: appointment.classes,
                           address: appointment.address
                       }
                   } }
               )
      when '1'
        render json: Success.new(
                   lessons: @user.lessons.joins(:course).available.page(params[:page]||1).collect { |lesson|
                     {
                         course: {
                             name: lesson.course.name,
                             type: lesson.course.type,
                             during: lesson.course.during,
                         },
                         available: (lesson.available-lesson.used),
                         exp: lesson.exp
                     }
                   }
               )
      when '2'
        render json: Success.new(
                   lessons: @user.lessons.joins(:course).exp.page(params[:page]||1).collect { |lesson|
                     {
                         course: {
                             name: lesson.course.name,
                             type: appointment.course.type,
                             price: appointment.course.price,
                             during: appointment.course.during,
                         },
                         available: (lesson.available-lesson.used),
                         exp: lesson.exp
                     }
                   }
               )
      else
        render json: Failure.new('未知到数据类型')
    end
  end

  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: Failure.new('还没有登录') if @user.nil?
  end
end
