class OrdersController < ApplicationController
  before_action :verify_auth_token, only: :index

  def index
    render json: {
               code: 1,
               data: {orders: @user.orders.page(params[:page]||1).collect { |order| order.as_json }}
           }
  end

  def create
    order = @user.orders.new(order_params)
    if order.save
      render json: {code: 1, data: {order: order.as_json}}
    else
      render json: {code: 1, message: '创建订单失败'}
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
