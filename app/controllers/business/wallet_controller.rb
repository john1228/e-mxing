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
                                     action: log.action,
                                     balance: log.balance,
                                     created: log.created_at.to_i
                                 }
                               })
    end
  end
end
