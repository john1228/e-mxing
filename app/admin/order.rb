ActiveAdmin.register Order do
  menu label: '订单', parent: '商品管理'
  config.batch_actions = false
  scope('0-全部', :all, default: true)
  scope('1-已付款', :unprocessed) { |scope| scope.where(status: Order::STATUS[:pay]) }
  scope('2-未付款', :processed) { |scope| scope.where(status: Order::STATUS[:unpay]) }
  filter :no, label: '订单号'
  filter :contact_name, label: '联系人'
  filter :contact_phone, label: '联系电话'
  filter :created_at, label: '订单日期'
  filter :pay_type, label: '支付方式', as: :select, collection: Order::PAY_TYPE
  filter :service_id, label: '服务号'
  filter :coach_id, label: '私教'
  actions :index, :show

  index do
    column('订单编号', :no)
    column('服务号') { |order|
      sku = Sku.find_by(sku: order.order_item.sku)
      link_to(sku.seller_user.profile.name, order_user_path(sku.seller_id), class: 'fancybox', data: {'fancybox-type' => 'ajax'})
    }
    column('买家') { |order|
      link_to(order.user.profile.name, order_user_path(order.user_id), class: 'fancybox', data: {'fancybox-type' => 'ajax'})
    }
    column('联系人', :contact_name)
    column('联系电话', :contact_phone)
    column('订单金额', :total)
    column('支付金额', :pay_amount)
    column('支付方式') { |order|
      case order.pay_type.to_i
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

  controller do
    def user
      @user = User.find_by(id: params[:id])
      render layout: false
    end
  end
end
