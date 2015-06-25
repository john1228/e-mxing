class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :wallet_logs
  attr_accessor :action
  after_update :create_wallet_log
  #action 以1开头为增加 以2开头的为减少
  ACTIONS = {buy_course: 1, check: 10}

  def as_json
    {
        balance: balance.to_f,
        coupons: coupons.split(',').size,
        bean: bean
    }
  end

  private
  def create_wallet_log
    coupons_change
    if coupons.split(',').size > coupons_was.split(',').size
      coupons_change = coupons.split(',') - coupons_was.split(',') #增加优惠券
    else
      coupons_change = "-#{(coupons_was.split(',') - coupons.split(',')).join(',')}" #减少优惠券
    end

    wallet_logs.create(
        action: action,
        balance: (balance-balance_was),
        coupons: coupons_change,
        bean: bean - bean_was
    )
  end
end
