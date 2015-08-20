module Shop
  class CouponsController < ApplicationController
    #私教评论列表
    def index
      render json: Success.new(
                 coupon: Coupon.where('end_date > ? and active=?', true).page(params[:page]||1)
             )
    end

    def update
      coupon = Coupon.find_by(id: params[:id])
      if coupon.present?
        if coupon.amount >0
          begin
            if coupon.update(amount: (coupon.amount -1))
              wallet = @user.wallet
              wallet.with_lock do
                wallet.coupons << coupon.id
                wallet.action = WalletLog::ACTIONS['兑换']
                wallet.save
              end
            end
          rescue Exception => exp
            render Failure.new('抢购失败，请刷新重试:' + exp.message)
          end
        else
          render json: Failure.new('该优惠券已抢光')
        end
      else
        render json: Failure.new('该优惠券已下架')
      end
    end
  end
end
