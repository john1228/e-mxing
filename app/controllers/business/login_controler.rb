module Business
  class LoginController < BaseController
    def update
      logger.info "#{params[:password]}-#{params[:new_password]}"
      if params[:password].present?
        if @coach.password.eql?(Digest::MD5.hexdigest("#{params[:password]}|#{@coach.salt}"))
          if @coach.update(password: params[:new_password])
            render json: {code: 1}
          else
            render json: {code: 0, message: '更新密码失败'}
          end
        else
          render json: {code: 0, message: '您输入到原密码错误'}
        end
      else
        render json: {code: 0, message: '请输入原密码'}
      end
    end

    def mobile
      coach = Coach.find_by(mobile: params[:username])
      if coach.present?
        submit_password = Digest::MD5.hexdigest("#{params[:password]}|#{coach.salt}")
        if coach.password.eql?(submit_password)
          Rails.cache.write("#{coach.token}|gyms", coach)
          render json: Success.new({coach: coach.summary_json})
        else
          render json: Failure.new('您输入的密码不正确')
        end
      else
        render json: Failure.new('您还未注册为私教')
      end
    end
  end
end