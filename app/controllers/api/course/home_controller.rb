module Api
  module Course
    class HomeController < ApplicationController
      before_action :verify_auth_token, only: [:coupons, :confirm_order]

      def index
        city = URI.decode(request.headers[:city]) rescue '上海'
        category = Category.find_by(name: params[:cat])
        courses = Sku.online.course.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
            where('address Like ?', '%'+ city + '%').where(course_type: category.item)
        case params[:sort]
          when 'smart'
            courses = courses.order(id: :desc).page(params[:page]||1)
          when 'fresh-asc'
            courses = courses.order(updated_at: :desc).order(id: :desc).page(params[:page]||1)
          when 'distance-asc'
            courses = courses.order('distance asc').order(id: :desc).page(params[:page]||1)
          when 'sale-desc'
            courses = courses.order(orders_count: :desc).order(id: :desc).page(params[:page]||1)
          when 'evaluate-asc'
            courses = courses.order(orders_count: :desc).order(id: :desc).page(params[:page]||1)
          when 'price-asc'
            courses = courses.order(selling_price: :asc).order(id: :desc).page(params[:page]||1)
          when 'price-desc'
            courses = courses.order(selling_price: :desc).order(id: :desc).page(params[:page]||1)
          else
            courses = []
        end
        render json: Success.new(course: courses)
      end

      def search
        city = URI.decode(request.headers[:city]) rescue '上海'
        category = Category.find_by(name: params[:cat])
        keyword = params[:keyword]
        courses = Sku.online.course.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
            where('address LIKE ?', '%'+ city + '%').
            where(course_type: category.item).
            where('address LIKE ? or course_name LIKE ?', "%#{keyword}%", "%#{keyword}%")
        case params[:sort]
          when 'smart'
            courses = courses.order(id: :desc).page(params[:page]||1)
          when 'fresh-asc'
            courses = courses.order(updated_at: :desc).order(id: :desc).page(params[:page]||1)
          when 'distance-asc'
            courses = courses.order('distance asc').order(id: :desc).page(params[:page]||1)
          when 'sale-desc'
            courses = courses.order(orders_count: :desc).order(id: :desc).page(params[:page]||1)
          when 'evaluate-asc'
            courses = courses.order(orders_count: :desc).order(id: :desc).page(params[:page]||1)
          when 'price-asc'
            courses = courses.order(selling_price: :asc).order(id: :desc).page(params[:page]||1)
          when 'price-desc'
            courses = courses.order(selling_price: :desc).order(id: :desc).page(params[:page]||1)
          else
            courses = []
        end
        render json: Success.new(course: courses)
      end


      def show
        sku = Sku.find(params[:sku])
        if sku.status.eql?(0)
          render json: Failure.new('您查看到商品已下架')
        else
          user = Rails.cache.fetch(request.headers[:token])
          concerned = nil
          limit = nil
          sku_limit = nil
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
          render json: Success.new(product: {
                                       sku: sku.id,
                                       name: sku.course_name,
                                       cover: sku.course_cover,
                                       market_price: sku.market_price.floor,
                                       selling_price: sku.selling_price.floor,
                                       store: sku.store||-1,
                                       score: sku.score,
                                       card_info: {
                                           type: sku.course_type,
                                           image: sku.product.image.map { |image| image.url },
                                           description: sku.product.description,
                                           special: sku.product.special,
                                           value: sku.product.card_type.value,
                                           valid_days: sku.product.card_type.valid_days,
                                           delay_days: sku.product.card_type.delay_days,
                                           prop: ({
                                               during: sku.product.prop.during,
                                               style: sku.product.prop.style,
                                               proposal: sku.product.prop.proposal
                                           } rescue {})
                                       },
                                       seller: {
                                           mxid: sku.seller_user.profile.mxid,
                                           name: sku.seller_user.profile.name,
                                           avatar: sku.seller_user.profile.avatar.url,
                                           mobile: sku.seller_user.profile.identity.eql?(1) ? sku.seller_user.mobile : sku.service.profile.mobile,
                                           identity: sku.seller_user.profile.identity_value,
                                           tags: sku.seller_user.profile.tags
                                       },
                                       address: [{
                                                     agency: sku.service.profile.name,
                                                     city: sku.service.profile.city,
                                                     addrss: (sku.service.profile.area||"") + (sku.service.profile.address||"")
                                                 }],
                                       buyers: {
                                           count: sku.orders_count,
                                           items: sku.buyers
                                       },
                                       comment: {
                                           count: sku.comments.count,
                                           items: sku.image_comments.take(5)
                                       },
                                       conerned: (concerned||0),
                                       limit: limit||sku_limit
                                   })
        end
      end

      def show_old
        sku = Sku.find(params[:sku])
        if sku.recommend.blank?&&sku.status.eql?(0)
          render json: Failure.new('您查看到商品已下架')
        else
          user = Rails.cache.fetch(request.headers[:token])
          concerned = nil
          limit = nil
          sku_limit = nil
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

      def coupons
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
          render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons, limit_category: Coupon::TYPE[:general]).where('end_date >= ?', Date.today))
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
            type: sku.course_type,
            cover: sku.course_cover,
            amount: params[:amount],
            during: sku.course_during,
            price: sku.selling_price,
            sku: sku.id
        }
        params.permit(:contact_name, :contact_phone, :pay_type, :coupon, order_item_attributes: [:name, :type, :cover, :amount, :during, :price, :sku])
      end


      def verify_auth_token
        @user = Rails.cache.read(request.headers[:token])
        render json: Failure.new(-1, '您还没有登录') if @user.nil?
      end
    end
  end
end
