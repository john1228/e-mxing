module CaptchaConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_captcha, only: :check
  end

  def send_sms(mobile, captcha)
    conn = Faraday.new(url: 'https://sandboxapp.cloopen.com:8883')
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    account = 'aaf98f894b0b8616014b19c5e46709c3'
    account_token = '6212e011d5634ff896a9a179c313c217'
    appid = 'aaf98f894b0b8616014b19c7261f09cd'
    templateid = '12107'
    auth = Base64.strict_encode64(account + ":" + timestamp)

    conn.headers['Accept'] = 'application/json'
    conn.headers['Authorization'] = auth
    conn.headers['Content-Type'] = 'application/json;charset=utf-8'

    sig = Digest::MD5.hexdigest(account + account_token + timestamp)
    params = {to: "#{mobile}", appId: appid, templateId: templateid, datas: ["#{captcha}", '30'], data: ''}
    response = conn.post "/2013-12-26/Accounts/#{account}/SMS/TemplateSMS?sig=#{sig}", params.to_json
    logger.info response.body
    Rails.cache.write(Digest::MD5.hexdigest(mobile), {mobile: mobile, captcha: captcha}, expires_in: 30*60)
  end

  def reset_pwd(mobile, captcha)
    conn = Faraday.new(url: 'https://sandboxapp.cloopen.com:8883')
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    account = 'aaf98f894b0b8616014b19c5e46709c3'
    account_token = '6212e011d5634ff896a9a179c313c217'
    appid = 'aaf98f894b0b8616014b19c7261f09cd'
    templateid = '12107'
    auth = Base64.strict_encode64(account + ":" + timestamp)

    conn.headers['Accept'] = 'application/json'
    conn.headers['Authorization'] = auth
    conn.headers['Content-Type'] = 'application/json;charset=utf-8'

    sig = Digest::MD5.hexdigest(account + account_token + timestamp)
    params = {to: "#{mobile}", appId: appid, templateId: templateid, datas: ["#{captcha}", '30'], data: ''}
    response = conn.post "/2013-12-26/Accounts/#{account}/SMS/TemplateSMS?sig=#{sig}", params.to_json
    logger.info response.body
    Rails.cache.write(Digest::MD5.hexdigest(mobile), {mobile: mobile, captcha: captcha}, expires_in: 30*60)
  end

  def check_captcha
    token = request.headers[:token]
    captcha = Rails.cache.fetch(token).fetch(:captcha)
    if captcha.blank?
      render json: {
                 code: 0,
                 message: '验证码已过期'
             }
    else
      #if params[:captcha].eql?(captcha)
      new_token = Digest::MD5.hexdigest(Rails.cache.fetch(token).fetch(:mobile)+Time.now.to_s)
      Rails.cache.write(new_token, Rails.cache.fetch(token).fetch(:captcha), expires_in: 30*60)
      render json: {
                 code: 1,
                 data: {token: new_token}
             }
      # else
      #   render json: {
      #              code: 0,
      #              message: '验证码不正确'
      #          }
      # end
    end
  end
end