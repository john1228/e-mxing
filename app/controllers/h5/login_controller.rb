module H5
  class LoginController < ApplicationController
    def mobile
      login_user = User.find_by(mobile: params[:username])
      if login_user.nil?
        render json: Failure.new('该用户还未注册')
      else
        if Blacklist.find_by(user: login_user).present?
          render json: Failure.new('该用户已经被用户举报封存，如有疑问，可联系客服人员咨询解封')
        else
          my_password = Digest::MD5.hexdigest("#{params[:password]}|#{login_user.salt}")
          if login_user.password.eql?(my_password)
            Rails.cache.write(login_user.token, login_user)
            render json: Success.new(user: login_user.summary_json)
          else
            render json: Failure.new('您输入的密码不正确')
          end
        end
      end
    end
  end
end