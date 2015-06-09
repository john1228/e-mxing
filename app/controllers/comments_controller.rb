class CommentsController < ApiController
  def show
    render json: {
               code: 1,
               data: {
                   comments: DynamicComment.where(dynamic_id: params[:no]).page(params[:page]||1).collect { |comment| comment.as_json }
               }
           }
  end

  def create
    comment = DynamicComment.new(user: @user, dynamic_id: params[:no], content: params[:content])
    if comment.save
      render json: {code: 1}
    else
      render json: {code: 0, message: '发表评论失败'}
    end
  end
end
