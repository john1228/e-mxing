module Shop
  class CommentsController < ApplicationController
    #私教评论列表
    def index
      if params[:type]

        render json: Success.new(comments: comment)
      end
    end

    def create

    end
  end
end
