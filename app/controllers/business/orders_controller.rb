module Business
  class OrdersController < BaseController
    def index
      render json: Success.new(orders: @coach.orders.collect { |order|
                                 {
                                     no: order.no,
                                     items: order.order_items.collect { |item| item.as_json },
                                     pay_type: order.pay_type,
                                     pay_amount: order.pay_amount,
                                     status: order.status,
                                     user: order.user.profile.summary_json
                                 }
                               })
    end

    def show
      order = @coach.orders.find_by(no: params[:no])
      if order.blank?
        render json: Failure.new('您查看到订单不存在')
      else
        render json: Success.new(
                   order: {
                       no: order.no,
                       items: order.order_items.collect { |item|
                         item.as_json
                       },
                       contact: {
                           name: order.contact_name,
                           phone: order.contact_phone
                       },
                       coupons: 0,
                       bean: order.bean,
                       pay_type: order.pay_type,
                       pay_amount: order.pay_amount,
                       status: order.status,
                       user: order.user.profile.summary_json
                   }
               )

      end
    end
  end
end