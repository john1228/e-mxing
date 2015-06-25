class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :wallet_logs
  attr_accessor :action
  after_update :create_wallet_log
  #action 以1开头为增加 以2开头的为减少
  ACTIONS = {buy_course: 1, check: 10, order_cancel: 11, pay_course: 2}

  def as_json
    {
        balance: balance.to_f,
        coupons: coupons.size,
        bean: bean
    }
  end

  private
  def create_wallet_log
    coupons_change
    if coupons.size > coupons_was.size
      coupons_change = coupons - coupons_was #增加优惠券
    else
      coupons_change = coupons_was- coupons #减少优惠券
    end
    wallet_logs.create(
        action: action,
        balance: (balance-balance_was),
        coupons: coupons_change,
        bean: bean - bean_was
    )
  end
end
