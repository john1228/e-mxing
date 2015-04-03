class LikeController < ApplicationController
  include LikeConcern

  def dynamic
    like = Like.new(user_id: @user.id, liked_id: params[:id], like_type: Like::Dynamic)
    if like.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '赞动态失败'
             }
    end
  end

  def showtime
    like = Like.new(user_id: @user.id, liked_id: params[:id], like_type: Like::Dynamic)
    if like.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '赞視頻秀失败'
             }
    end
  end
end
