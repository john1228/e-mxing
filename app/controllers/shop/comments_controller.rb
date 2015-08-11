module Shop
  class CommentsController < ApplicationController
    #私教评论列表
    def index
      sku = Sku.find_by(sku: params[:sku])
      if params[:page].eql?('1')
        render json: Success.new(count: sku.comments.count, comments: sku.comments.page(params[:page]||1))
      else
        render json: Success.new(comments: sku.comments.page(params[:page]||1))
      end
    end
  end
end
