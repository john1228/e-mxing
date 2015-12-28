module Mine
  class OrdersController < BaseController
    def index
      case params[:status]
        when '0'
          orders = @user.orders.where.not(status: Order::STATUS[:delete]).page(params[:page]||1)
        when '1'
          orders = @user.orders.where(status: Order::STATUS[:unpaid]).page(params[:page]||1)
        when '2'
          orders = @user.orders.where(status: Order::STATUS[:pay]).page(params[:page]||1)
        else
          orders = []
      end
      render json: Success.new(
                 orders: orders.collect { |order|
                   seller = Sku.find_by(sku: order.order_item.sku).seller_user
                   {
                       no: order.no,
                       coach: seller.profile.summary_json,
                       items: [order.order_item],
                       pay_type: order.pay_type,
                       pay_amount: order.pay_amount,
                       status: order.status,
                       created_at: order.updated_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
                 }
             )
    end

    def show
      order = @user.orders.find_by(no: params[:no])
      if order.blank?
        render json: Failure.new('您查看到订单不存在')
      else
        seller = Sku.find_by(sku: order.order_item.sku).seller_user
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

    def unprocessed
      render json: Success.new(unprocessed: @user.orders.where(status: Order::STATUS[:unpaid]).count)
    end

    def cancel
      order = @user.orders.find_by(no: params[:no])
      if order.status.eql?(Order::STATUS[:unpaid])
        if order.update(status: Order::STATUS[:cancel])
          render json: Success.new
        else
          render json: Failure.new('取消订单失败')
        end
      else
        render json: Failure.new('不是未付款订单，不能取消')
      end
    end

    def delete
      order = @user.orders.find_by(no: params[:no])
      if order.status.eql?(Order::STATUS[:cancel]||order.status.eql?(:complete))
        if order.update(status: Order::STATUS[:delete])
          render json: Success.new
        else
          render json: Failure.new('删除订单失败')
        end

      else
        render json: Failure.new('该订单还未完成处理，不能删除')
      end
    end
  end
end