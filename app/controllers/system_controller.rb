class SystemController < ApplicationController
  before_action :verify_auth_token, except: :active

  def feedback
    Feedback.create(user_id: @user.id, content: params[:content], contact: params[:contact])
    render json: {code: 1}
  end

  def report
    Report.create(user_id: @user.id, report_type: params[:type], report_id: params[:id], content: params[:content])
    render json: {code: 1}
  end

  def sign
    check = Check.new(user: @user, date: Date.today)
    if check.save
      render json: Success.new
    else
      render json: Failure.new('您已经签到')
    end
  end

  def active
    device = Device.new(active_params)
    if device.save
      render json: Success.new(token: device.token)
    else
      render json: Failure.new('激活失败')
    end
  end

  def auto_login
    AutoLogin.create(user: @user)
    render json: Success.new
  end

  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '您还未登录'} if @user.blank?
  end

  def active_params
    params.permit(:name, :system, :device, :channel, :version, :ip)
  end
end
