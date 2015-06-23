module Callback
  class AlipayController < BaseController
    def callback
      params.map { |k, v|
        logger.info "#{k}<<<#{v}"
      }
      trade_no = params[:trande_no]
      order_no = params[:out_trade_no]
      buyer_id = params[:buyer_id]
      buyer_email = params[:buyer_email]
      pay_amount = params[:price]
      order = Order.find_by(no: order_no)
      order.update(status: Order::STATUS[:pay]) #if order.pay_amount.eql?(pay_amount.to_d)
      Transaction.create(no: trade_no, order_no: order_no, buyer_id: buyer_id, buyer_email: buyer_email, source: Transaction::SOURCE[:alipay], price: pay_amount)
      render text: 'success'
    end
  end
end
