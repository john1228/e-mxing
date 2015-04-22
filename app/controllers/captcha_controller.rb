class CaptchaController < ApplicationController
  include CaptchaManager

  def regist
    profile = Profile.find_by(mobile: params[:mobile])
    if profile.nil?
      captcha = Captcha.create(mobile: params[:mobile])
      send_sms(params[:mobile], captcha.captcha)
      mobile_token = Digest::MD5.hexdigest(params[:mobile])
      Rails.cache.write(mobile_token, {action: 'regist', mobile: params[:mobile], captcha: captcha.captcha}, expires_in: 30*60)
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
      captcha = Captcha.create(mobile: params[:mobile])
      send_sms(params[:mobile], captcha.captcha)
      mobile_token = Digest::MD5.hexdigest(params[:mobile])
      Rails.cache.write(mobile_token, {action: 'change', mobile: mobile, captcha: captcha.captcha}, expires_in: 30*60)
      render json: {
                 code: 1,
                 data: {token: mobile_token}
             }
    end
  end


  def binding
    profile = Profile.find_by(mobile: params[:mobile])
    if profile.nil?
      render json: {code: 0, message: '该号码已绑定'}
    else
      captcha = Captcha.create(mobile: params[:mobile])
      send_sms(params[:mobile], captcha.captcha)
      Rails.cache.write("#{@user.id}_binding", {action: 'binding', mobile: params[:mobile], captcha: captcha.captcha}, expires_in: 30*60)
      render json: {code: 1}
    end
  end


  def check
  end
end
