class CaptchaController < ApplicationController
  include CaptchaManager
  before_action :verify_auth_token, only: :binding
  before_action :check_captcha, only: :check

  def regist
    user = User.find_by(mobile: params[:mobile])
    if user.nil?
      captcha = generate_captcha
      SmsJob.perform_now(params[:mobile], SMS['验证码'], ["#{captcha}", '30'])
      mobile_token = Digest::MD5.hexdigest(params[:mobile])
      Rails.cache.write(mobile_token, {action: 'regist', mobile: params[:mobile], captcha: captcha}, expires_in: 30.minutes)
      render json: Success.new({token: mobile_token})
    else
      render json: Failure.new('该号码已注册或已绑定')
    end
  end

  def change
    user = User.find_by(mobile: params[:mobile])
    if user.nil?
      render json: Failure.new('该号码还未注册')
    else
      captcha = generate_captcha
      SmsJob.perform_now(params[:mobile], SMS['验证码'], ["#{captcha}", '30'])
      mobile_token = Digest::MD5.hexdigest(params[:mobile])
      Rails.cache.write(mobile_token, {action: 'change', mobile: params[:mobile], captcha: captcha}, expires_in: 30.minutes)
      render json: Success.new(token: mobile_token)
    end
  end


  def binding
    user = User.find_by(mobile: params[:mobile])
    if user.nil?
      captcha = generate_captcha
      SmsJob.perform_now(params[:mobile], SMS['验证码'], ["#{captcha}", '30'])
      Rails.cache.write("#{@user.id}_binding", {action: 'binding', mobile: params[:mobile], captcha: captcha}, expires_in: 30.minutes)
      render json: Success.new
    else
      render json: Failure.new('该号码已绑定')
    end
  end


  def check
  end

  private
  def generate_captcha
    sample_str = %w"0 1 2 3 4 5 6 7 8 9"
    sample_str.sample(6).join('')
  end

  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '您还未登录'} if @user.nil?
  end
end
