class OrdersController < ApplicationController
  before_action :verify_auth_token, only: :index

  def index
    render json: Success.new(
               orders: @user.orders.page(params[:page]||1).collect { |order|
                 {
                     no: order.no,
                     coach: order.coach.profile.summary_json,
                     items: order.order_items.collect { |item| item.as_json },
                     pay_type: order.pay_type,
                     pay_amount: order.pay_amount,
                     status: order.status,
                 }
               }
           )
  end

  def show
    order = Order.find_by(no: params[:no])
    if order.blank?
      render json: Success.new(
                 order: {
                     no: order.no,
                     coach: order.coach.profile.summary_json,
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
                 }
             )
    else
      render json: Failure.new('您查看到订单不存在')
    end
  end

  def unprocessed
    render json: Success.new(unprocessed: @user.orders.where(status: Order::STATUS[:unpay]).count)
  end

  def callback
  end

  private
  def verify_auth_token
    @user = Rails.cache.read(request.headers[:token])
    render json: {code: -1, message: '您还没有登录'} if @user.blank?
  end

  def order_params
    params.permit(:contact_name, :contact_phone, :items, :coupons, :bea, :pay_type)
  end
end
