class LikeController < ApiController

  def index
    case params[:type]
      when 'dynamic'
        likes = Like.where(liked_id: params[:id], like_type: Like::DYNAMIC).page(params[:page]||1)
      when 'person'
        likes = Like.where(liked_id: params[:id], like_type: Like::PERSON).page(params[:page]||1)
    end
    render json: Success.new(like: likes)
  end

  def create
    case params[:type]
      when 'dynamic'
        Like.create(user_id: @user.id, liked_id: params[:no], like_type: Like::DYNAMIC)
      when 'person'
        user = User.find_by_mxid(params[:mxid])
        user.likes.create(user_id: @user.id)
    end
    render json: Success.new
  end

  def count
    begin
      render json: Success.new(likes: @user.likes.count)
    rescue
      render json: Failure.new('获取赞信息失败')
    end
  end
end
