module Api
  module Dynamic
    class CommentsController < ApplicationController
      before_filter :auth_user, only: :create

      def index
        render json: Success.new(comments: DynamicComment.where(dynamic_id: params[:id]).page(params[:page]||1).map { |comment|
                                   {
                                       user: {
                                           mxid: comment.user.profile.mxid,
                                           name: comment.user.profile.name,
                                           avatar: comment.user.profile.avatar.url,
                                           age: comment.user.profile.age,
                                           gender: comment.user.profile.gender.to_i,
                                           identity: comment.user.profile.identity,
                                       },
                                       content: HarmoniousDictionary.clean(comment.content),
                                       created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                                   }
                                 })
      end

      def create
        comment = DynamicComment.new(comment_params)
        if comment.save
          render json: Success.new
        else
          render json: Failure.new('发布评论失败！')
        end
      end

      private
      def comment_params
        params.permit(:content).merge(user_id: @user.id, dynamic_id: params[:id])
      end

      def auth_user
        @user = Rails.cache.fetch(request.headers[:token])
        render json: Failure.new(-1, '您还未登录') if @user.blank?
      end
    end
  end
end
