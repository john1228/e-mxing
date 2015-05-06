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
    begin
      user.likes.create(user_id: @user.id)
      render json: {code: 1}
    rescue
      render json: {code: 0, message: '赞失败'}
    end
  end

  def count
    user = User.find_by_mxid(params[:mxid])
    begin
      render json: {code: 1, data: {likes: user.likes.count}}
    rescue
      render json: {code: 0, message: '获取赞信息失败'}
    end
  end
end
