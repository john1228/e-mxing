class SystemController < ApiController
  before_action :verify_auth_token

  def feedback
    Feedback.create(user_id: @user.id, content: params[:content], contact: params[:contact])
    render json: {code: 1}
  end

  def report
    Report.create(user_id: @user.id, report_type: params[:type], report_id: params[:id], content: params[:content])
    render json: {code: 1}
  end

  def sign
    check = Check.new(user: @user)
    if check.save
      render json: Success.new
    else
      render json: Failure.new('您已经签到')
    end
  end

  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: 0, message: '您还未登录'} if @user.blank?
  end
end
