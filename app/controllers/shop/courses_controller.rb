module Shop
  class CoursesController < ApplicationController
    before_action :verify_auth_token, only: [:pre_order, :confirm_order]

    def index
      logger.info "所选城市: #{request.headers[:city]}"
      city = request.headers['city']||'上海'
      filters = {course_type: params[:cat]} if params[:cat].present?
      case params[:sort]
        when 'smart'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order('distance asc').page(params[:page]||1)
        when 'fresh-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(updated_at: :desc).page(params[:page]||1)
        when 'distance-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order('distance asc').page(params[:page]||1)
        when 'evaluate-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(orders_count: :desc).page(params[:page]||1)
        when 'price-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(selling_price: :asc).page(params[:page]||1)
        when 'price-desc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(selling_price: :desc).page(params[:page]||1)
        else
          courses = []
      end
      render json: Success.new(courses: courses)
    end

    def show
      sku = Sku.find_by(sku: params[:sku])
      if sku.blank?
        render json: Failure.new('您查看到课程已下架')
      else
        user = Rails.cache.fetch(request.headers[:token])
        if user.present?
          concerned = Concerned.find_by(sku: params[:sku], user: user).present? ? 1 : 0
          if sku.limit >0
            purchased = sku.limit_detect(user.id)
            if purchased >= sku.limit
              limit = 0
            else
              limit = (sku.limit - purchased)
            end
          end
        end
        render json: Success.new(
                   course: sku.detail.merge(conerned: concerned||0, limit: limit||sku.limit)
               )
      end
    end

    def pre_order
      amount = params[:amount].to_i
      sku = Sku.find_by(sku: params[:sku])
      if sku.store==0
        render json: Failure.new('库存不足')
      elsif sku.store>0 && sku.store < amount
        render json: Failure.new('库存不足')
      elsif sku.limit > 0 && (sku.limit_detect(@user.id) + amount) > sku.limit
        render json: Failure.new('已超出每人购买数量')
      else
        render json: Success.new(coupons: @user.wallet.valid_coupons(params[:sku], amount))
      end
    end

    def confirm_order
      order = @user.orders.new(order_params.merge(status: Order::STATUS[:unpay]))
      if order.save
        render json: Success.new(order: order)
      else
        render json: Failure.new(order.errors.full_messages.join(','))
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
