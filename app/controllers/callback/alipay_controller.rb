module Callback
  class AlipayController < BaseController
    def callback
      trade_no = params[:trande_no]
      order_no = params[:out_trade_no]
      buyer_id = params[:buyer_id]
      buyer_email = params[:buyer_email]
      pay_amount = params[:price]
      order = Order.find_by(no: order_no)
      order.update(status: Order::STATUS[:pay], pay_type: Order::PAY_TYPE[:alipay]) #if order.pay_amount.eql?(pay_amount.to_d)
      Transaction.create(no: trade_no, order_no: order_no, buyer_id: buyer_id, buyer_email: buyer_email, source: Transaction::SOURCE[:alipay], price: pay_amount)

      course = order.order_items.first.course
      unless course.guarantee.eql?(Course::GUARANTEE)
        coach = course.coach
        coach.wallet.update(balance: (coach.wallet.balance+BigDecimal(pay_amount)), action: WalletLog::ACTIONS['消费'])
      end
      render text: 'success'
    end
  end
end
