module Shop
  class RecommendsController < ApplicationController
    #私教评论列表
    def index
      case params[:type]
        when 'course'
          render json: Success.new(course: Sku.recommended.page(params[:page]||1))
        when 'coach'
          render json: Success.new(course: Coach.recommended.page(params[:page]||1).map { |coach| coach.summary_json.merge(tip: coach.recommend.recommended_tip) })
        when 'coupon'
          render json: Success.new(coupon: Coupon.all)
        when 'other'
          render json: Success.new()
        else
          render json: Failure.new('非法请求')
      end
    end
  end
end
