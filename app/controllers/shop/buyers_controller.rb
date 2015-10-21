module Shop
  class BuyersController < ApplicationController
    #私教评论列表
    def index
      render json: Success.new(buyer: Order.joins(:order_item).where(status: 2).where('order_items.sku LIKE ?', params[:sku][0, params[:sku].rindex('-')] + '%').
                                   order(id: :desc).page(params[:page]||1).pluck(:user_id).map { |user_id|
                                 user = User.find(user_id)
                                 user.summary_json
                               })
    end
  end
end
