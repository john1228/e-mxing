module Business
  class WalletController < BaseController
    def index
      @coach.create_wallet if @coach.wallet.blank?
      render json: Success.new(wallet: @coach.wallet)
    end

    def coupons
      render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons.split(',')))
    end
  end
end
