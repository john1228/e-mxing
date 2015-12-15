module Business
  class LoginController < ApplicationController
    def mobile
      coach = Coach.find_by(mobile: params[:username])
      if coach.present?
        submit_password = Digest::MD5.hexdigest("#{params[:password]}|#{coach.salt}")
        if coach.password.eql?(submit_password)
          Rails.cache.write("gyms-#{coach.token}", coach)
          render json: Success.new(coach: {
                                       token: coach.token,
                                       mxid: coach.profile.mxid,
                                       name: coach.profile.name,
                                       avatar: coach.profile.avatar.url,
                                       gender: coach.profile.gender,
                                       identity: coach.profile.identity_value,
                                       age: coach.profile.age,
                                       birthday: coach.profile.birthday,
                                       signature: coach.profile.signature,
                                       business: coach.profile.business,
                                       clock: coach.clocks.count
                                   })
        else
          render json: Failure.new('您输入的密码不正确')
        end
      else
        render json: Failure.new('您还未注册为私教')
      end
    end
  end
end