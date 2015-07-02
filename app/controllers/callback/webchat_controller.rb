module Callback
  class WebchatController < BaseController
    def callback
      request_data = Hash.from_xml(request.body.read)['xml'].symbolize_keys
      trade_no = request_data[:transaction_id]
      order_no = request_data[:out_trade_no]
      buyer_id = request_data[:openid]
      pay_amount = (request_data[:total_fee].to_i/100.to_f)
      transaction = Transaction.find_by(no: trade_no, source: Transaction::SOURCE[:webchat])
      if transaction.blank?
        order = Order.find_by(no: order_no)
        order.update(status: Order::STATUS[:pay], pay_type: Order::PAY_TYPE[:alipay]) if order.pay_amount.eql?(pay_amount.to_d)&&order.status.eql?(Order::STATUS[:pay])
        Transaction.create(no: trade_no, order_no: order_no, buyer_id: buyer_id, source: Transaction::SOURCE[:webchat], price: pay_amount)

        course = order.order_items.first.course
        unless course.guarantee.eql?(Course::GUARANTEE)
          coach = course.coach
          coach.wallet.update(balance: (coach.wallet.balance+BigDecimal(pay_amount.tof)), action: WalletLog::ACTIONS['消费'])
        end
      end

      render text: 'success'
    end
  end
end
