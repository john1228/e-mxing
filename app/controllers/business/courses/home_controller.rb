module Business
  module Courses
    class HomeController < BaseController
      def index
        if params[:type].eql?('general')
          sku_list = Sku.course.online.where(seller_id: @coach.service_id).order(id: :desc).page(params[:page]||1)
        else
          sku_list = Sku.course.online.where(seller_id: @coach.id).order(id: :desc).page(params[:page]||1)
        end
        render json: Success.new(
                   course: sku_list.map { |sku|
                     {
                         id: sku.id,
                         name: sku.course_name,
                         cover: sku.course_cover,
                         during: sku.product.prop.during,
                         price: sku.selling_price.floor,
                         concerns: sku.concerns_count
                     }
                   }
               )
      end

      def show
        course = Sku.online.find(params[:id])
        render json: Success.new(
                   course: {
                       id: course.id,
                       name: course.course_name,
                       image: course.product.image.map { |image| image.url },
                       price: course.selling_price.floor,
                       guarantee: 0,
                       score: course.score,
                       type: course.product.card_type.value,
                       style: course.product.prop.style,
                       exp: course.product.card_type.valid_days,
                       during: course.product.prop.during,
                       proposal: course.product.prop.proposal,
                       intro: course.product.description,
                       special: course.product.special,
                       venue: @coach.service.profile.name,
                       purchased: course.orders_count,
                       concerns: course.concerns_count,
                       address: course.address,
                       service: @coach.service.profile.service
                   }
               )
      end


      def create
        begin
          Product.transaction do
            membership_card_type = MembershipCardType.course.new(card_type_params)
            membership_card_type.save
            product = membership_card_type.products.build(product_params)
            product.build_prop(prop_params)
            product.save
            product.sku.online!
            render json: Success.new
          end
        rescue Exception => exp
          render json: Failure.new('创建卡类型失败'+ exp.message)
        end
      end

      def update
        course = @coach.courses.find_by(id: params[:id])
        if course.update(update_params)
          render json: Success.new
        else
          render json: Failure.new('更新课程失败')
        end
      end

      def destroy
        sku = Sku.find_by(sku: params[:id])
        if sku.offline!
          render json: Success.new
        else
          render json: Failure.new('删除课程失败')
        end
      end

      private
      def card_type_params
        {
            service_id: @coach.service.id,
            name: params[:name],
            value: params[:type],
            valid_days: params[:exp],
            price: params[:price],
            remark: '私教端添加用户'
        }
      end

      def product_params
        upload_images = (0..8).map { |index| params[index.to_s.to_sym] }
        upload_images.compact!
        {
            name: params[:name],
            image: upload_images,
            description: params[:intro],
            special: params[:special],
            selling_price: params[:price],
            market_price: params[:price],
            service_id: @coach.service.id,
            seller_id: @coach.id,
            store: -1,
            limit: -1
        }
      end

      def prop_params
        {
            during: params[:during],
            proposal: params[:proposal],
            style: params[:style]
        }
      end

    end
  end
end