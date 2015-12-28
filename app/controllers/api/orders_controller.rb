module Api
  class OrdersController < ApplicationController
    before_action :verify_auth_token

    def show
      order = Order.find_by(no: params[:no])
      if order.blank?
        render json: Failure.new('您查看到订单不存在')
      else
        seller = Sku.find(order.order_item.sku).seller_user
        render json: Success.new(
                   order: {
                       no: order.no,
                       coach: seller.profile.summary_json,
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
                       created: order.updated_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
               )
      end
    end

    def confirm
      order = Order.find_by(no: params[:no])
      if order.blank?
        render json: Failure.new('您查看到订单不存在')
      else
        if order.update(user: @user)
          render json: Success.new
        else
          render json: Failure.new('确认订单失败:' + order.errors.messags.values.joins(';'))
        end
      end
    end

    protected
    def verify_auth_token
      @user = Rails.cache.read(request.headers[:token])
      render json: Failure.new(-1, '您还没有登录') if @user.nil?
    end
  end
end