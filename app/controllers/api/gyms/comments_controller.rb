module Api
  module Gyms
    class CommentsController < BaseController
      #私教评论列表
      def index
        render json: Success.new(comment: @coach.comments.page(params[:page]||1)).map { |comment|
                 {
                     user: {
                         mxid: comment.user.profile.mxid,
                         name: comment.user.profile.name,
                         avatar: comment.user.profile.avatar.url,
                         age: comment.user.profile.age,
                         gender: comment.user.profile.gender.to_i,
                         identity: comment.user.profile.identity_value,
                     },
                     score: comment.score,
                     content: comment.content,
                     images: comment.image.map { |image| {url: image.url} },
                     created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                 }
               }
      end
    end
  end
end
