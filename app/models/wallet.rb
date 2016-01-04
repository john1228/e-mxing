class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :wallet_logs
  attr_accessor :action, :source, :operator

  after_update :create_wallet_log

  def as_json
    {
        balance: balance.to_f.round(2),
        coupons: Coupon.where('end_date >= ?', Date.today).where(id: coupons).count,
        bean: bean
    }
  end

  def valid_coupons(sku, amount)
    #TODO: 筛选可用的优惠券,暂时不做商品区分
    sku = Sku.find_by(sku: sku)
    total = sku.selling_price * amount
    Coupon.where(id: coupons, limit_category: Coupon::TYPE[:general]).where('min <= ? and start_date <= ? and end_date >= ?', total, Date.today, Date.today)
  end

  private
  def create_wallet_log
    wallet_logs.create(
        action: action,
        balance: balance - balance_was,
        integral: integral_was - integral,
        coupons: coupons.size > coupons_was.size ? (coupons - coupons_was) : (coupons_was - coupons),
        bean: bean - bean_was,
        source: source,
        operator: operator
    )
  end
end
