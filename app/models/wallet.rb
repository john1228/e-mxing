class Wallet < ActiveRecord::Base
  belongs_to :user

  def as_json
    {
        balance: balance.to_f,
        coupons: Coupon.where(id: coupons.split(',')).collect { |coupon| coupon.as_json },
        bean: bean
    }
  end
end
