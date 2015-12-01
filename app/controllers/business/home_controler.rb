module Business
  class HomeController < BaseController

    def index
      render json: Success.new(
                 balance: @coach.wallet.balance.to_f.round(2),
                 order: Order.pay.where(coach_id: @coach.id).count,
                 appoint: Appointment.where(coach_id: @coach.id).count
             )
    end

    def update
      if params[:password].present?
        if @coach.password.eql?(Digest::MD5.hexdigest("#{params[:password]}|#{@coach.salt}"))
          if @coach.update(password: params[:new_password])
            Rails.cache.write("#{@coach.token}|gyms", @coach.reload)
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
  end
end