module Api
  class CouponsController < ApplicationController
    def index
      user = Rails.cache.fetch(request.headers[:token])
      render json: Success.new(
                 coupon: Coupon.where('end_date >= ? and active=? and amount > used', Date.today, true).order(end_date: :asc).
                     page(params[:page]||1).map { |coupon|
                   if user.blank?
                     coupon.as_json.merge(have: 0)
                   else
                     coupon.as_json.merge(have: user.wallet.coupons.include?(coupon.id) ? 1 : 0)
                   end
                 }
             )
    end

    def update
      user = Rails.cache.fetch(request.headers[:token])
      coupon = available_coupon?(user)
      if coupon
        if user.wallet.coupons.include?(coupon.id)
          render json: Failure.new('您已经领取过该优惠券')
        else
          if coupon.update(used: (coupon.used + 1))
            wallet = user.wallet
            wallet.with_lock do
              wallet.coupons << coupon.id
              wallet.action = WalletLog::ACTIONS['兑换']
              wallet.save
            end
            render json: Success.new
          else
            render json: Failure.new('领取失败:'+ coupon.errors.messages.values.join(';'))
          end
        end
      else
        render json: Failure.new('领取失败:您已经领取过该优惠券或者该优惠券已过期')
      end
    end

    def help
      render layout: false
    end

    protected
    def available_coupon?(user)
      Coupon.where('id=? and amount>used', params[:id].to_i).first unless user.wallet.coupons.include?(params[:id].to_i)
    end
  end
end
