module Shop
  class BuyersController < ApplicationController
    #私教评论列表
    def index
      render json: Success.new(buyer: User.where(id: Order.includes(:order_item).where('order_items.sku LIKE ?', params[:sku][0, params[:sku].rindex('-')] + '%').order(id: :desc).limit(params[:page]||1).pluck(:user_id)).map { |user|
                                 user.summary_json
                               })

    end
  end
end
