module Business
  class LoginController < ApplicationController
    def sns
      coach = Coach.find_by(sns: "#{params[:sns_name]}_#{params[:sns_id]}")
      if coach.present?
        Rails.cache.write(coach.token, coach)
        render json: {code: 1, data: {coach: coach.summary_json}}
      else
        render json: {code: 0, message: '您还未注册为私教.'}
      end
    end

    def mobile
      coach = Coach.find_by(mobile: params[:username])
      if coach.present?
        submit_password = Digest::MD5.hexdigest("#{params[:password]}|#{coach.salt}")
        if coach.password.eql?(submit_password)
          Rails.cache.write(coach.token, coach)
          render json: {code: 1, data: {coach: coach.summary_json}}
        else
          render json: {code: 0, message: '您输入的密码不正确'}
        end
      else
        render json: {code: 0, message: '您还未注册为私教'}
      end
    end
  end
end