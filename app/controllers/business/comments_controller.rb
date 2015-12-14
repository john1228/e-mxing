module Business
  class CommentsController < BaseController
    #获取线上学员列表
    def index
      render json: Success.new(
                 comment: @coach.comment.order(id: :desc).map { |comment|
                 }
             )
    end
  end
end