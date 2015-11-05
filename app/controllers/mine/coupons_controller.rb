module Mine
  class CouponsController < BaseController
    def index
      case params[:tag]
        when 'valid'
          coupon = Coupon.where(id: @user.wallet.coupon).where('end_date >= ?', Date.today).page(params[:page]||1)
        when 'expired'
          coupon = Coupon.where(id: @user.wallet.coupon).where('end_date < ?', Date.today).page(params[:page]||1)
        when 'used'
          coupon = Coupon.where(id: @user.orders.where.not(coupons: nil).pluck(:coupons)).page(params[:page]||1)
        else
          coupon = []
      end
      render json: Success.new(coupon: coupon.map { |item|
                                 {
                                     no: item.id,
                                     name: item.name,
                                     discount: item.discount.to_i,
                                     info: item.info,
                                     start_date: item.start_date,
                                     end_date: item.end_date,
                                     limit_category: item.limit_category,
                                     limit_ext: item.limit_ext,
                                     min: item.min
                                 }
                               })
    end
  end
end
