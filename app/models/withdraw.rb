class Withdraw < ActiveRecord::Base
  belongs_to :coach
  before_create :reduce
  after_update :refund
  STATUS ={'提现请求' => 0, '已处理' => 1, '成功' => 2, '失败' => 3}

  validates_numericality_of :amount, greater_than_or_equal_to: 200
  private
  def reduce
    begin
      wallet = Wallet.find_or_create_by(user_id: coach_id)
      wallet.with_lock do
        wallet.balance = wallet.balance - amount
        wallet.action = WalletLog::ACTIONS['提现']
        wallet.save
      end
    rescue
      false
    end
  end

  def refund
    if status.eql?(STATUS['失败']) && !status.eql?(status_was)
      wallet = Wallet.find_or_create_by(user_id: coach_id)
      wallet.with_lock do
        wallet.balance = wallet.balance + amount
        wallet.action = WalletLog::ACTIONS['提现退款']
        wallet.save
      end
    end
  end
end
