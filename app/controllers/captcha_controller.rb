class CaptchaController < ApplicationController
  include CaptchaManager

  def regist
    user = User.find_by(mobile: params[:mobile])
    if user.nil?
      captcha = generate_captcha
      send_sms(params[:mobile], captcha)
      mobile_token = Digest::MD5.hexdigest(params[:mobile])
      Rails.cache.write(mobile_token, {action: 'regist', mobile: params[:mobile], captcha: captcha}, expires_in: 30*60)
      render json: {
                 code: 1,
                 data: {token: mobile_token}
             }
    else
      render json: {
                 code: 0,
                 message: '该号码已注册或已绑定'
             }
    end
  end

  def change
    profile = Profile.find_by(mobile: params[:mobile])
    if profile.nil?
      render json: {
                 code: 0,
                 message: '该号码还未注册'
             }
    else
      captcha = generate_captcha
      send_sms(params[:mobile], captcha)
      mobile_token = Digest::MD5.hexdigest(params[:mobile])
      Rails.cache.write(mobile_token, {action: 'change', mobile: params[:mobile], captcha: captcha}, expires_in: 30*60)
      render json: {
                 code: 1,
                 data: {token: mobile_token}
             }
    end
  end


  def binding
    user = User.find_by(mobile: params[:mobile])
    if user.nil?
      captcha = generate_captcha
      send_sms(params[:mobile], captcha)
      Rails.cache.write("#{@user.id}_binding", {action: 'binding', mobile: params[:mobile], captcha: captcha}, expires_in: 30*60)
      render json: {code: 1}
    else
      render json: {code: 0, message: '该号码已绑定'}
    end
  end


  def check
  end

  private
  def generate_captcha
    sample_str = %w"0 1 2 3 4 5 6 7 8 9"
    sample_str.sample(6).join('')
  end
end
