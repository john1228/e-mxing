module Api
  module Course
    class CommentsController < ApplicationController
      #私教评论列表
      def index
        sku = Sku.find_by(sku: params[:sku])
        if params[:page].eql?('1')
          render json: Success.new(count: sku.comments.count, comments: sku.comments.page(params[:page]||1)).map { |comment|
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
                       images: comment.image.map { |image| image.url },
                       created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
                 }
        else
          render json: Success.new(comments: sku.comments.page(params[:page]||1)).map { |comment|
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
                       images: comment.image.map { |image| image.url },
                       created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
                 }
        end
      end
    end
  end
end
