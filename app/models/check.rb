class Check < ActiveRecord::Base
  belongs_to :user
  validate :has_not_signed
  after_create :polite

  def has_not_signed
    signed = Check.where(user: user, created_at: Time.zone.now.at_beginning_of_day..Time.zone.now.end_of_day)
    false if signed
  end

  def polite
    #TODO 现在没有连续签到奖励
    user.wallet.update(bean: (user.wallet.bean + 5), action: 13)
  end
end
