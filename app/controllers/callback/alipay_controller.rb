module Callback
  class AlipayController < BaseController
    def callback
      trade_no = params[:trade_no]
      order_no = params[:out_trade_no]
      buyer_id = params[:buyer_id]
      buyer_email = params[:buyer_email]
      pay_amount = params[:price]
      Transaction.create(no: trade_no, order_no: order_no, buyer_id: buyer_id, buyer_email: buyer_email, source: Transaction::SOURCE[:alipay], price: pay_amount)
      render text: 'success'
    end
  end
end
