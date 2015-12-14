module Business
  module FaceToFaces
    class HomeController < BaseController
      def courses
        render json: Success.new(
                   course: Sku.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1).map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         during: sku.course_during,
                         price: sku.selling_price.to_i
                     }
                   }
               )
      end

      def cards

      end


      def create
        sku = Sku.find(params[:sku])
        order = Order.face_to_face.new(
            contact_name: params[:name],
            contact_phone: params[:mobile],
            pay_type: 1,
            pay_amount: params[:pay_amount],
            order_item_attributes: {
                name: sku.course_name,
                type: sku.course_type,
                cover: sku.course_cover,
                amount: params[:amount],
                during: sku.course_during,
                price: sku.selling_price,
                sku: sku.id
            },
            giveaway: params[:giveaway]
        )
        if order.save
          #美型支付
          if params[:pay_method].eql?('mxing')
            @qrcode = RQRCode::QRCode.new("http://#{host}/mine/orders/show?no=#{order.no}", :size => 4, :level => :h)
            render layout: false, action: :mxing
          elsif params[:pay_method].eql?('alipay')
            params = {
                :out_trade_no => order.no,
                :subject => "美型-订单编号#{order.no}",
                :total_fee => order.pay_amount
            }
            @url = trade_create_by_user_url(params)
            render layout: false, action: :alipay
          end
          #支付宝
        else
          render json: Failure.new('下单失败:' + order.errors.messages.values.join(';'))
        end
      end

      def mxing
        @qrcode = RQRCode::QRCode.new("http://news.163.com", :size => 20, :level => :l)
        render layout: false
      end

      def alipay
      end

      private
      def face_to_face_params
        params.permit(:sku, :name, :mobile, :amount, :pay_amount, :giveaway)
      end
    end
  end
end