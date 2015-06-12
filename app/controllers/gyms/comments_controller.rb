module Gyms
  class CommentsController < BaseController
    #私教评论列表
    def index
      case params[:type]
        when 'photographer'
        when 'course'
          comments = []
        else
          comments = []
      end
      render json: Success.new(comments: comments)
    end
  end
end
