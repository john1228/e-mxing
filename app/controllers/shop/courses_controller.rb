module Shop
  class CoursesController < ApplicationController
    def index
      render json: Success.new(
                 courses: Sku.page(params[:page]||1)
             )
    end

    def show
      sku = Sku.find_by(sku: params[:sku])
      if sku.blank?
        render json: Failure.new('您查看到课程已下架')
      else
        user = Rails.cache.fetch(request.headers[:token])
        render json: Success.new(
                   sku: sku.detail.merge(conerned: user ? 0 : 1)
               )
      end
    end

    def pre_order
      user = Rails.cache.fetch(request.headers[:token])
      if user.blank?
        render json: Failure.new(-1, '您还没有登录')
      else
        render json: Success.new(coupons: user.wallet.valid_coupons)
      end
    end

    def confirm_order
      
    end
  end
end
