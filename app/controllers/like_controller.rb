class LikeController < ApplicationController
  include LoginManager

  def dynamic
    like = Like.new(user_id: @user.id, liked_id: params[:no], like_type: Like::DYNAMIC)
    if like.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '赞动态失败'
             }
    end
  end

  def person
    user = User.find_by_mxid(params[:mxid])
    like = Like.new(user_id: @user.id, liked_id: user.showtime.id, like_type: Like::PERSON)
    if like.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '赞失败'
             }
    end
  end
end
