class Withdraw < ActiveRecord::Base
  belongs_to :coach
  after_create :reduce

  private
  def reduce
    wallet = Wallet.find_or_create_by(user_id: coach_id)
    wallet.update(balance: (wallet.balance - amount), action: WalletLog::ACTIONS['提现'])
  end
end
