module CaptchaManager
  extend ActiveSupport::Concern

  included do
    before_action :need_user, only: :binding
    before_action :check_captcha, only: :check
  end

  def need_user
    logger.info request.headers[:token]
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: 0, message: '您还未登录'} if @user.nil?
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
    conn.post "/2013-12-26/Accounts/#{account}/SMS/TemplateSMS?sig=#{sig}", params.to_json
  end


  def check_captcha
    token = request.headers[:token]
    cache_info = Rails.cache.fetch(token)
    if cache_info.blank?
      render json: {code: 0, message: '验证码已过期'}
    else
      binding_user = nil
      if cache_info.is_a?(User)
        binding_user = cache_info
        token = "#{binding_user.id}_binding"
        cache_info = Rails.cache.fetch(token)
      end
      captcha = cache_info.fetch(:captcha) rescue nil
      if params[:captcha].eql?(captcha)
        mobile = cache_info.fetch(:mobile) rescue nil
        action = cache_info.fetch(:action) rescue nil
        Rails.cache.delete(token)
        if action.eql?('regist')
          new_token = Digest::MD5.hexdigest("#{mobile}||#{rand(100)}")
          Rails.cache.write(new_token, mobile)
          render json: {code: 1, data: {token: new_token}}
        elsif action.eql?('change')
          user = User.find_by(mobile: mobile)
          update_result = user.update(password: params[:password]) rescue false
          if update_result
            Rails.cache.write(user.token, user)
            render json: {code: 1, data: {user: user.summary_json}}
          else
            render json: {code: 0, message: '修改密码失败'}
          end
        elsif action.eql?('binding')
          bind_result = binding_user.update(mobile: mobile) rescue false
          if bind_result
            render json: {code: 1}
          else
            render json: {code: 0, message: '绑定手机号失败'}
          end
        else
          render json: {code: 0, message: '未知类型'}
        end
      else
        render json: {code: 0, message: '验证码不正确'}
      end
    end
  end
end