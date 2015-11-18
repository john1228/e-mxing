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
        like = Like.dynamic.new(user_id: @user.id, liked_id: params[:no])
        if like.save
          render json: Success.new
        else
          render json: Failure.new('您已经对该动态点过赞')
        end
      when 'person'
        user = User.find_by_mxid(params[:mxid])
        like = Like.person.new(user_id: @user.id, liked_id: user.id)
        if like.save
          render json: Success.new
        else
          render json: Failure.new('您已经对该用户点过赞')
        end
      else
        render json: Failure.new('无效的请求')
    end
  end

  def count
    begin
      render json: Success.new(likes: @user.likes.count)
    rescue
      render json: Failure.new('获取赞信息失败')
    end
  end
end
