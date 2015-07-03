module Mine
  class WalletController < BaseController
    def index
      @user.create_wallet if @user.wallet.blank?
      render json: Success.new(wallet: @user.wallet)
    end

    def coupons
      render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons))
    end

    def detail
      render json: Success.new(detail: @user.wallet.wallet_logs.where.not(balance: 0).page(params[:page]||1).map { |log|
                                 {
                                     id: log.id,
                                     action: log.action_name,
                                     balance: log.balance,
                                     created: log.created_at.to_i
                                 }
                               })
    end

    def exchange
      exchange_code = params[:code]
      #TODO:优惠码兑换
      render json: Failure.new('无效到兑换码')
    end
  end
end