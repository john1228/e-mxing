module Api
  module Gyms
    class CommentsController < BaseController
      #私教评论列表
      def index
        render json: Success.new(comment: @coach.comments.page(params[:page]||1))
      end
    end
  end
end
