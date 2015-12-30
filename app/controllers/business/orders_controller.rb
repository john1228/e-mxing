module Business
  class OrdersController < BaseController
    def index
      render json: Success.new(orders: @coach.orders.pay.page(params[:page]||1).collect { |order|
                                 {
                                     no: order.no,
                                     contact: {
                                         name: order.contact_name,
                                         phone: order.contact_phone
                                     },
                                     items: [{
                                                 sku: order.order_item.sku,
                                                 cover: order.order_item.cover,
                                                 name: order.order_item.name,
                                                 type: order.order_item.type,
                                                 during: order.order_item.during,
                                                 price: order.order_item.price,
                                                 amount: order.order_item.amount,
                                                 card: order.order_item.course.product.present? ? 1 : 0,
                                                 card_type: (order.order_item.course.product.card_type.card_type rescue '')
                                             }],
                                     pay_amount: order.pay_amount,
                                     status: order.status,
                                     user: order.user.profile,
                                     type: order.order_type,
                                     giveaway: order.giveaway,
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
                       items: [{
                                   sku: order.order_item.sku,
                                   cover: order.order_item.cover,
                                   name: order.order_item.name,
                                   type: order.order_item.type,
                                   during: order.order_item.during,
                                   price: order.order_item.price,
                                   amount: order.order_item.amount,
                                   card: order.order_item.course.product.present? ? 1 : 0,
                                   card_type: (order.order_item.course.product.card_type.card_type rescue '')
                               }],
                       contact: {
                           name: order.contact_name,
                           phone: order.contact_phone
                       },
                       coupons: order.coupons.blank? ? 0 : Coupon.where(id: order.coupons.split(',')).sum(:discount).to_i,
                       bean: order.bean,
                       pay_amount: order.pay_amount,
                       type: order.order_type,
                       giveaway: order.giveaway,
                       status: order.status,
                       user: order.user.profile,
                       created: order.updated_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
               )

      end
    end
  end
end