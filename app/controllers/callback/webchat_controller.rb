module Callback
  class WebchatController < BaseController
    def callback
      request_data = Hash.from_xml(request.body.read)['xml'].symbolize_keys
      trade_no = request_data[:transaction_id]
      order_no = request_data[:out_trade_no]
      buyer_id = request_data[:openid]
      pay_amount = (request_data[:total_fee].to_i/100.to_f)
      Transaction.create(no: trade_no, order_no: order_no, buyer_id: buyer_id, source: Transaction::SOURCE[:webchat], price: pay_amount)
      render text: 'success'
    end
  end
end
