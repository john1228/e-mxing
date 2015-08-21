module Shop
  class CouponsController < ApiController
    #私教评论列表
    def index
      @user = Rails.cache.fetch(request.headers[:token])
      render json: Success.new(
                 coupon: Coupon.where('end_date > ? and active=? and amount > used', Date.today, true).
                     page(params[:page]||1).map { |coupon|
                   if @user.blank?
                     coupon.as_json.merge(have: 0)
                   else
                     coupon.as_json.merge(have: @user.wallet.coupons.include?(coupon.id) ? 1 : 0)
                   end
                 }
             )
    end

    def update
      wallet = @user.wallet
      render json: Failure.new('您已经拥有该优惠券') if wallet.coupons.include?(params[:id].to_i)
      coupon = Coupon.where('id=? and amount>used', params[:id].to_i)
      if coupon.present?
        if coupon.update_attributes(used: (coupon.used + 1))
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
end
