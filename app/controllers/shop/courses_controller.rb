module Shop
  class CoursesController < ApplicationController
    before_action :verify_auth_token, only: [:pre_order, :confirm_order]

    def index
      city = URI.decode(request.headers[:city]) rescue '上海'
      filters = nil
      filters = {course_type: params[:cat]} if params[:cat].present?
      case params[:sort]
        when 'smart'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order('distance asc').order(id: :desc).page(params[:page]||1)
        when 'fresh-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(updated_at: :desc).order(id: :desc).page(params[:page]||1)
        when 'distance-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order('distance asc').order(id: :desc).page(params[:page]||1)
        when 'evaluate-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(orders_count: :desc).order(id: :desc).page(params[:page]||1)
        when 'price-asc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(selling_price: :asc).order(id: :desc).page(params[:page]||1)
        when 'price-desc'
          courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
              where('address Like ?', city + '%').where(filters).order(selling_price: :desc).order(id: :desc).page(params[:page]||1)
        else
          courses = []
      end
      render json: Success.new(courses: courses)
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
      order = @user.orders.platform.new(order_params)
      if order.save
        render json: Success.new(order: order)
      else
        render json: Failure.new(order.errors.messages.values.join(';'))
      end
    end

    private
    def order_params
      sku = Sku.find(params[:sku])
      params[:order_item_attributes] = {
          name: sku.course_name,
          type: MembershipCard.card_types[sku.product.card_type.card_type],
          cover: sku.course_cover,
          amount: params[:amount],
          during: (sku.product.prop.during rescue ''),
          price: sku.selling_price,
          sku: sku.id
      }
      params.permit(:contact_name, :coupon, :contact_phone, :pay_type, order_item_attributes: [:name, :type, :cover, :amount, :during, :price, :sku])
    end

    def verify_auth_token
      @user = Rails.cache.read(request.headers[:token])
      render json: Failure.new(-1, '您还没有登录') if @user.nil?
    end
  end
end
