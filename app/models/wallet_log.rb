class WalletLog < ActiveRecord::Base
  ACTIONS = {'卖课收入' => 110, '上课收入' => 111, '签到' => 120, '兑换' => 130, '订单取消' => 131, '提现' => 210, '转账' => 211, '消费' => 212}

  def action_name
    ACTIONS.key(action)
  end
end
