module Business
  class HomeController < BaseController
    def index
      render json: Success.new(
                 balance: @coach.wallet.balance.to_f.round(2),
                 order: Order.pay.where(coach_id: @coach.id).count,
                 appoint: Appointment.where(coach_id: @coach.id).count,
                 comment: Comment.where(sku: (Sku.where(seller_id: @coach.id).pluck(:sku)).uniq).count,
                 tool: TOOL
             )
    end

    def password
      if params[:password].present?
        if @coach.password.eql?(Digest::MD5.hexdigest("#{params[:password]}|#{@coach.salt}"))
          if @coach.update(password: params[:new_password])
            Rails.cache.write("#{@coach.token}|gyms", @coach.reload)
            render json: Success.new
          else
            render json: Failure.new("更新密码失败:#{@coach.erorrs.messages.values.join(';')}")
          end
        else
          render json: Failure.new('您输入到原密码错误')
        end
      else
        render json: Failure.new('请输入原密码')
      end
    end

    def update
      profile = @coach.profile
      if profile.update(update_params)
        render json: Success.new
      else
        render json: Failure.new('修改失败:'+profile.errors.messages.values.join(';'))
      end
    end

    private
    def update_params
      params.permit(:name, :avatar, :gender, :birthday, :signature, :business)
    end
  end
end