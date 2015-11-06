module Api
  module Course
    class HomeController < ApplicationController
      before_action :verify_auth_token, only: [:pre_order, :confirm_order]

      def index
        city = URI.decode(request.headers[:city]) rescue '上海'
        category = Category.find_by(name: params[:cat])
        render json: Success.new(
                   course: Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
                       where('address Like ?', city + '%').where(course_type: category.item).
                       order('distance asc').order(id: :desc).page(params[:page]||1)
               )
      end

      def search
        city = URI.decode(request.headers[:city]) rescue '上海'
        category = Category.find_by(name: params[:cat])
        keyword = params[:keyword]
        render json: Success.new(
                   course: Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
                       where('address Like ?', city + '%').where('course_name like ? or address like ?', keyword + '%', keyword + '%').where(course_type: category.item).
                       order('distance asc').order(id: :desc).page(params[:page]||1)
               )
      end


      def show
        sku = Sku.find_by(sku: params[:sku])
        if sku.recommend.blank?&&sku.status.eql?(0)
          render json: Failure.new('您查看到课程已下架')
        else
          user = Rails.cache.fetch(request.headers[:token])
          if user.present?
            concerned = Concerned.find_by(sku: params[:sku], user: user).present? ? 1 : 0
            sku_limit = sku.limit || -1
            if sku_limit >0
              purchased = sku.limit_detect(user.id)
              if purchased >= sku_limit
                limit = 0
              else
                limit = (sku_limit - purchased)
              end
            end
          end
          render json: Success.new(
                     course: sku.detail.merge(conerned: concerned||0, limit: limit||sku_limit)
                 )
        end
      end

      def pre_order
        amount = params[:amount].to_i
        sku = Sku.find_by(sku: params[:sku])
        sku_store = sku.store||-1
        sku_limit = sku.limit||-1
        if sku_store==0
          render json: Failure.new('库存不足')
        elsif sku_store>0 && sku_store < amount
          render json: Failure.new('库存不足')
        elsif sku_limit > 0 && (sku.limit_detect(@user.id) + amount) > sku_limit
          render json: Failure.new('已超出每人购买数量')
        else
          render json: Success.new(coupons: @user.wallet.valid_coupons(params[:sku], amount))
        end
      end

      def confirm_order
        order = @user.orders.new(order_params.merge(status: Order::STATUS[:unpaid]))
        if order.save
          render json: Success.new(order: order)
        else
          render json: Failure.new(order.errors.messages.values.join(';'))
        end
      end

      private
      def order_params
        params.permit(:sku, :amount, :coupon, :pay_type, :contact_name, :contact_phone)
      end

      def verify_auth_token
        @user = Rails.cache.read(request.headers[:token])
        render json: Failure.new(-1, '您还没有登录') if @user.nil?
      end
    end
  end
end
