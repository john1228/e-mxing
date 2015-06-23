module Mine
  class WalletController < BaseController
    def index
      @user.create_wallet if @user.wallet.blank?
      render json: Success.new(wallet: @user.wallet)
    end

    def coupons
      render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons.split(',')))
    end

    def detail
      render json: Success.new(detail: @user.wallet.wallet_logs.where.not(balance: 0).page(params[:page]||1).map { |log|
                                 {
                                     id: log.id,
                                     action: log.action,
                                     balance: log.balance.abs,
                                     created: log.created_at.to_i
                                 }
                               })
    end

    def exchange
      render json: Success.new(coupons: Coupon.all)
    end
  end
end