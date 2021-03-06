class Withdraw < ActiveRecord::Base
  belongs_to :coach
  before_create :reduce
  after_update :refund
  STATUS ={'提现请求' => 0, '已处理' => 1, '成功' => 2, '失败' => 3}

  validates_numericality_of :amount, greater_than_or_equal_to: 200, message: '提现金额不能少于200元'
  validates_presence_of :account, message: '请填写支付宝账户'
  validates_presence_of :name, message: '请填写支付宝账户对应的实名'

  #enum status: [:request, :processed, :success, :failed]
  private
  def reduce
    wallet = Wallet.find_or_create_by(user_id: coach_id)
    if wallet.update(balance: wallet.balance - amount, action: WalletLog::ACTIONS['提现'])
      true
    else
      false
    end
  end

  def refund
    if status.eql?(STATUS['失败']) && !status.eql?(status_was)
      wallet = Wallet.find_or_create_by(user_id: coach_id)
      if wallet.update(balance: wallet.balance - amount, action: WalletLog::ACTIONS['提现'])
        true
      else
        false
      end
    end
  end
end
