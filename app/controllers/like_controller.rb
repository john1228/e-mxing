class LikeController < ApplicationController
  include LoginManager

  def create
    like = Like.new(user_id: @user.id, liked_id: params[:no], like_type: Like::Dynamic)
    if like.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '赞动态失败'
             }
    end
  end
end
