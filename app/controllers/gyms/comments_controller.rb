module Gyms
  class CommentsController < ApplicationController
    #私教评论列表
    def index
      #TODO: 私教评论
      if params[:page].eql?('1')
        render json: Success.new(comments: Comments.page(params[:page]||1))
      else
        render json: Success.new(count: Comments.count, comments: Comments.page(params[:page]||1))
      end
    end
  end
end
