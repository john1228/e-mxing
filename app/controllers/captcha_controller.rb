class CaptchaController < ApplicationController
  include CaptchaConcern

  def regist
    profile = Profile.find_by(mobile: params[:mobile])
    if profile.nil?
      captcha = Captcha.create(mobile: params[:mobile])
      send_sms(params[:mobile], captcha.captcha)
      render json: {
                 code: 1,
                 data: {token: Digest::MD5.hexdigest(params[:mobile])}
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
      captcha = Captcha.create(mobile: params[:mobile])
      send_sms(params[:mobile], captcha.captcha)
      render json: {
                 code: 1,
                 data: {token: Digest::MD5.hexdigest(params[:mobile])}
             }
    end
  end

  def check
  end
end
