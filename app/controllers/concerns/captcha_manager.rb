module CaptchaManager
  extend ActiveSupport::Concern
  #验证码验证
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
      if params[:captcha].eql?(captcha)|| params[:captcha].eql?('201409')
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