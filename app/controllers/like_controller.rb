class LikeController < ApiController

  def index
    case params[:type]
      when 'dynamic'
        likes = Like.dynamic.where(liked_id: params[:id]).order(id: :desc).page(params[:page]||1)
      when 'person'
        likes = Like.person.where(liked_id: params[:id]).order(id: :desc).page(params[:page]||1)
      else
        likes = []
    end
    render json: Success.new(like: likes)
  end

  def create
    case params[:type]
      when 'dynamic'
        Like.dynamic.create(user_id: @user.id, liked_id: params[:no])
      when 'person'
        user = User.find_by_mxid(params[:mxid])
        Like.person.create(user_id: @user.id, liked_id: user.id)
      else
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
