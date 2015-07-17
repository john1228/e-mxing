class Withdraw < ActiveRecord::Base
  belongs_to :coach
  after_create :reduce

  private
  def reduce
    wallet = Wallet.find_by(user: coach_id)
    wallet.update(balance: (coach.wallet.balance - amount), action: WalletLog::ACTIONS['提现'])
  end
end
