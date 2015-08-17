module Shop
  class BuyersController < ApplicationController
    #私教评论列表
    def index
      render json: Success.new(buyer: User.where(id: Order.joins(:order_item).
                                                     where(status: 2).
                                                     where('order_items.sku LIKE ?', params[:sku][0, params[:sku].rindex('-')] + '%').
                                                     order(id: :desc).pluck(:user_id)).page(params[:page]||1).map { |user|
                                 user.summary_json
                               })

    end
  end
end
