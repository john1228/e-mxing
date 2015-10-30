module Business
  class OrdersController < BaseController
    def index
      render json: Success.new(orders: @coach.orders.where(status: Order::STATUS[:pay]).page(params[:page]||1).collect { |order|
                                 {
                                     no: order.no,
                                     items: [order.order_item],
                                     pay_type: order.pay_type,
                                     pay_amount: order.pay_amount,
                                     status: order.status,
                                     user: order.user.profile
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
                       items: [order.order_item],
                       contact: {
                           name: order.contact_name,
                           phone: order.contact_phone
                       },
                       coupons: order.coupons.blank? ? 0 : Coupon.where(id: order.coupons.split(',')).sum(:discount).to_i,
                       bean: order.bean,
                       pay_type: order.pay_type,
                       pay_amount: order.pay_amount,
                       status: order.status,
                       user: order.user.profile,
                       created: order.updated_at.to_i
                   }
               )

      end
    end
  end
end