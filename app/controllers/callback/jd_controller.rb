module Callback
  class JdController < BaseController
    def callback
      params.map { |k, v|
        logger.info "#{k}<<<#{v}"
      }
      # trade_no = params[:out_trade_no]
      # pay_amount = params[:price]
      # order = Order.find_by(no: trade_no)
      # order.update(status: Order::STATUS[:pay]) if order.pay_amount.eql?(pay_amount.to_d)
      render text: 'success'
    end
  end
end
