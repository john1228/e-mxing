class Withdraw < ActiveRecord::Base
  belongs_to :coach
  after_create :reduce

  private
  def reduce
    coach.wallet.update(balance: (coach.wallet.balance - amount), action: WalletLog::ACTIONS['提现'])
  end
end
