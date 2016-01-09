module Business
  class HomeController < BaseController
    def index
      render json: Success.new(home_info)
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
        @coach.reload
        Rails.cache.write("gyms-#{@coach.token}", @coach)
        render json: Success.new(coach: {
                                     token: @coach.token,
                                     mxid: profile.mxid,
                                     name: profile.name,
                                     avatar: profile.avatar.url,
                                     gender: profile.gender,
                                     identity: profile.identity_value,
                                     age: profile.age,
                                     birthday: profile.birthday,
                                     signature: profile.signature,
                                     business: profile.business,
                                     clock: @coach.clocks.count
                                 })
      else
        render json: Failure.new('修改失败:'+ profile.errors.messages.values.join(';'))
      end
    end

    private
    def update_params
      params.permit(:name, :avatar, :gender, :birthday, :signature, :business)
    end

    def home_info
      coach_orders = @coach.orders.pay
      selling_sku = Sku.where(seller_id: @coach.id).pluck(:sku).uniq
      {
          balance: @coach.wallet.balance.to_f.round(2),
          order: coach_orders.count,
          appoint: MembershipCardLog.joins(:membership_card).checkin.confirm.where(membership_cards: {order_id: coach_orders.pluck(:id)}),
          comment: Comment.where(sku: selling_sku).count,
          tool: TOOL
      }
    end
  end
end