class OrdersController < ApplicationController
  before_action :verify_auth_token, only: [:index, :show]

  def index
    case params[:status]
      when '0'
        order = @user.orders.page(params[:page]||1)
      when '1'
        order = @user.orders.unpay.page(params[:page]||1)
      when '2'
        order = @user.orders.pay.page(params[:page]||1)
      else
        order = []
    end
    render json: Success.new(
               orders: order.collect { |order|
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
    order = @user.orders.find_by(no: params[:no])
    if order.blank?
      render json: Failure.new('您查看到订单不存在')
    else
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

    end
  end

  def unprocessed
    render json: Success.new(unprocessed: @user.orders.where(status: Order::STATUS[:unpay]).count)
  end

  def cancel
    order = Order.find_by(no: params[:no])
    if order.status.eql?(Order::STATUS[:unpay])
      render json: Success.new
    else
      render json: Failure.new('不是未付款订单，不能取消')
    end
  end

  def delete
    order = Order.find_by(no: params[:no])
    if order.status.eql?(Order::STATUS[:cancel]||order.status.eql?(:complete))
      render json: Success.new
    else
      render json: Failure.new('该订单还未完成处理，不能删除')
    end
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
