module Business
  class WalletController < BaseController
    def index
      @coach.create_wallet if @coach.wallet.blank?
      render json: Success.new(wallet: @coach.wallet)
    end

    def coupons
      render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons.split(',')))
    end

    def detail
      render json: Success.new(detail: @coach.wallet.wallet_logs.where.not(balance: 0).page(params[:page]||1).map { |log|
                                 {
                                     id: log.id,
                                     action: log.action_name,
                                     balance: log.balance,
                                     created: log.created_at.to_i
                                 }
                               })
    end

    def withdraw
      if @coach.wallet.balance >= BigDecimal(params[:amount])
        withdraw_request = Withdraw.new(coach_id: @coach.id, account: params[:account], name: params[:name], amount: params[:amount])
        if withdraw_request.save
          render json: Success.new
        else
          render json: Failure.new('申请提现请求处理失败')
        end
      else
        render json: Failure.new('余额不足，不能提现')
      end
    end
  end
end
