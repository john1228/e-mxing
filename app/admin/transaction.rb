ActiveAdmin.register Transaction do
  menu label: '交易流水'

  filter :no, label: '交易流水号'
  filter :order_no, label: '订单号'

  index do
    column '交易流水号', :no
    column '订单号', :order_no
    column '支付方式', :source
    column '支付账户', :buyer_id
    column '支付金额' do |price|
      price.to_f
    end
    column '支付时间' do |transaction|
      transaction.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
