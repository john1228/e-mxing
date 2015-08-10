module Gyms
  class CommentsController < ApplicationController
    #私教评论列表
    def index
      #TODO: 私教评论
      coach = Coach.find_by_mxid(params[:mxid])
      if params[:page].eql?('1')
        render json: Success.new(comments: coach.comments.page(params[:page]||1))
      else
        render json: Success.new(count: coach.comments.count, comments: coach.comments.page(params[:page]||1))
      end
    end
  end
end
