ActiveAdmin.register Transaction do
  menu label: '交易流水'

  filter :no, label: '交易流水号'
  filter :order_no, label: '订单号'
  filter :created_at, label: '支付时间'
  csv do
    column('公众号') { |transaction| Service.find_by(id: Order.find_by(no: transaction.order_no).service_id).profile.name }
    column('地址') { |transaction| Service.find_by(id: Order.find_by(no: transaction.order_no).service_id).profile.address }
    column('私教') { |transaction| Coach.find_by(id: Order.find_by(no: transaction.order_no).coach_id).profile.name rescue '' }
    column('订单号') { |transaction| transaction.order_no }
    column('下单时间') { |transaction| Order.find_by(no: transaction.order_no).created_at.localtime.strftime('%Y-%m-%d %H:%M:%S') }
    column('支付流水') { |transaction| transaction.no }
    column('支付类型') { |transaction| transaction.source }
    column('支付UID') { |transaction| transaction.buyer_id }
    column('支付账户') { |transaction| transaction.buyer_email }
    column('支付金额') { |transaction| transaction.price.to_i }
    column('支付时间') { |transaction| transaction.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S') }
  end

  actions :index
  index do
    column '交易流水号', :no
    column '订单号', :order_no
    column '支付方式', :source
    column '支付账户', :buyer_id
    column '支付金额' do |transaction|
      "#{transaction.price.to_f}元"
    end
    column '支付时间' do |transaction|
      transaction.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
