ActiveAdmin.register Order do
  menu label: '订单', parent: '课程'
  config.batch_actions = false
  scope('0-全部', :all, default: true)
  scope('1-已付款', :unprocessed) { |scope| scope.where(status: Order::STATUS[:pay]) }
  scope('2-未付款', :processed) { |scope| scope.where(status: Order::STATUS[:unpay]) }
  filter :no, label: '订单号'
  filter :contact_name, label: '联系人'
  filter :contact_phone, label: '联系电话'

  index do
    column('订单编号', :no)
    column('联系人', :contact_name)
    column('联系电话', :contact_phone)
    column('订单金额', :total)
    column('支付金额', :pay_amount)
    column('支付方式') { |order|
      case order.pay_type
        when 1
          '支付宝'
        when 2
          '微信'
        when 3
          '京东'
      end
    }
    column('状态') { |order|
      case order.status
        when -1
          status_tag('已删除', :error)
        when 0
          status_tag('已取消', :error)
        when 1
          status_tag('未付款', :warn)
        when 2
          status_tag('已付款', :ok)
      end
    }
    column('时间') { |order| order.updated_at.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
