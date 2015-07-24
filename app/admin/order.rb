ActiveAdmin.register Order do
  menu label: '订单', parent: '课程'
  config.batch_actions = false
  scope('0-全部', :all, default: true)
  scope('1-已付款', :unprocessed) { |scope| scope.where(status: Order::STATUS['未处理']) }
  scope('2-未付款', :processed) { |scope| scope.where(status: Withdraw::STATUS['已处理']) }
  filter :no, label: '订单号'
  filter :contact_name, label: '联系人'
  filter :contact_phone, label: '联系电话'

  index do
    column('订单编号', :no)
    column('联系人', :contact_name)
    column('联系电话', :contact_phone)
    column('订单金额', :total)
    column('支付金额', :pay_amount)
    column('支付方式', :pay_type)
    column('状态', :status)
    column('时间') { |order| order.updated_at.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
