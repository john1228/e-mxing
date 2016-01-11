module Business
  module FaceToFaces
    class HomeController < BaseController

      def index
        case params[:type]
          when 'courses'
            render json: Success.new(
                       course: Sku.course.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |sku|
                         {
                             id: sku.id,
                             name: sku.course_name,
                             cover: sku.course_cover,
                             during: sku.product.prop.during,
                             price: sku.selling_price.to_i
                         }
                       }
                   )
          when 'membership_cards'
            render json: Success.new(
                       card: Sku.online.where(seller_id: @coach.service.id)
                                 .where.not(course_type: Sku.course_types['course'])
                                 .order(id: :desc).page(params[:page]||1).map { |sku|
                         {
                             id: sku.id,
                             name: sku.course_name,
                             cover: sku.course_cover,
                             price: sku.selling_price.to_i,
                             type: sku.product.card_type.card_type,
                             value: sku.product.card_type.value,
                             valid_days: sku.product.card_type.valid_days||0,
                             delay_days: sku.product.card_type.delay_days||0,
                             concerns: sku.concerns_count
                         }
                       }
                   )
          when 'general'
            render json: Success.new(
                       course: Sku.course.online.where(seller_id: @coach.service_id).order(id: :desc).page(params[:page]||1).map { |sku|
                         {
                             id: sku.id,
                             name: sku.course_name,
                             cover: sku.course_cover,
                             during: sku.course_during,
                             price: sku.selling_price.to_i
                         }
                       }
                   )
          else
            render json: Failure.new('无效的请求')
        end
      end


      def discount
        coach_discount = CoachDiscount.find_by(coach_id: @coach.id, card_id: params[:card])
        if coach_discount.present?
          render json: Success.new(
                     discount: coach_discount.discount,
                     giveaway: coach_discount.giveaway
                 )
        else
          default_discount = CoachDiscountDefault.where(coach_id: @coach.id)
          default_discount = CoachDiscountDefault.new(discount: 80, giveaway_cash: 50, giveaway_count: 5, giveaway_day: 20) if default_discount.blank?
          product = Sku.find(params[:card]).product
          if product.card_type.stored?
            render json: Success.new(
                       discount: default_discount.discount,
                       giveaway: default_discount.giveaway_cash,
                   )
          elsif product.card_type.measured?
            render json: Success.new(
                       discount: default_discount.discount,
                       giveaway: default_discount.giveaway_count,
                   )
          elsif product.card_type.clocked?
            render json: Success.new(
                       discount: default_discount.discount,
                       giveaway: default_discount.giveaway_day,
                   )
          else
            render json: Success.new(
                       discount: 100,
                       giveaway: 0
                   )
          end
        end
      end


      def create
        sku = Sku.find(params[:sku])
        @order = @coach.orders.face_to_face.new(
            contact_name: params[:name],
            contact_phone: params[:mobile],
            pay_type: 1,
            custom_pay_amount: params[:pay_amount],
            order_item_attributes: {
                name: sku.course_name,
                type: sku.course_type,
                cover: sku.course_cover,
                amount: params[:amount],
                during: (sku.product.prop.during rescue ''),
                price: sku.selling_price,
                sku: sku.id
            },
            giveaway: params[:giveaway],
            seller_id: @coach.id,
        )
        if @order.save
          #美型支付
          if params[:pay_method].eql?('mxing')
            @qrcode = RQRCode::QRCode.new({no: @order.no}.to_json, :size => 2, :level => :l)
            render layout: false, action: :mxing
          elsif params[:pay_method].eql?('alipay')
            params = {
                :out_trade_no => @order.no,
                :subject => "美型-订单编号#{@order.no}",
                :total_fee => @order.pay_amount
            }
            @url = trade_create_by_user_url(params)
            logger.info "====d#{@url}"
            render layout: false, action: :alipay
          end
          #支付宝
        else
          render json: Failure.new('下单失败:' + order.errors.messages.values.join(';'))
        end
      end

      def paid
      end

      private
      def face_to_face_params
        params.permit(:sku, :name, :mobile, :amount, :pay_amount, :giveaway)
      end
    end
  end
end