module Api
  class CouponsController < ApplicationController
    def update
      wallet = @user.wallet
      if wallet.coupons.include?(params[:id].to_i)
        render json: Failure.new('您已经拥有该优惠券')
      else
        coupon = Coupon.where('id=? and amount>used', params[:id].to_i).first
        if coupon.present?
          if coupon.update(used: (coupon.used + 1))
            wallet.with_lock do
              wallet.coupons << coupon.id
              wallet.action = WalletLog::ACTIONS['兑换']
              wallet.save
            end
            render json: Success.new
          else
            render json: Failure.new('领取失败')
          end
        else
          render json: Failure.new('该优惠券已下架')
        end
      end
    end

    def help
      render layout: false
    end
  end
end
