class Wallet < ActiveRecord::Base
  belongs_to :user

  def as_json
    {
        balance: balance.to_f,
        coupons: coupons.split(',').size,
        bean: bean
    }
  end
end
