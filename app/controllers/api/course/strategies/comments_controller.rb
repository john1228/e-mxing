module Api
  module Course
    module Strategies
      class CommentsController < ApplicationController
        before_filter :auth_user, only: :create

        def index
          comments = StrategyComment.where(strategy_id: params[:id]).order(id: :desc).page(params[:page]||1)
          render json: Success.new(
                     comment: comments.map { |comment|
                       {
                           user: {
                               mxid: comment.user.profile.mxid,
                               name: comment.user.profile.name,
                               avatar: comment.user.profile.avatar.url,
                               age: comment.user.profile.age,
                               gender: comment.user.profile.gender.to_i,
                               identity: comment.user.profile.identity_value,
                           },
                           content: comment.content,
                           created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                       }
                     }
                 )
        end

        def latest
          strategy = Strategy.find(params[:id])
          render json: Success.new(
                     comment: {
                         amount: strategy.comment_count,
                         item: strategy.comments.order(id: :desc).limit(3).map { |comment|
                           {
                               user: {
                                   mxid: comment.user.profile.mxid,
                                   name: comment.user.profile.name,
                                   avatar: comment.user.profile.avatar.url,
                                   age: comment.user.profile.age,
                                   gender: comment.user.profile.gender.to_i,
                                   identity: comment.user.profile.identity_value,
                               },
                               content: comment.content,
                               created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                           }
                         }
                     }
                 )
        end

        def create
          strategy_comment = StrategyComment.new(comment_params)
          if strategy_comment.save
            render json: Success.new
          else
            render json: Failure.new('发布失败:'+ strategy_comment.errors.messages.values.join(';'))
          end
        end

        private
        def comment_params
          params.permit(:content).merge(user_id: @user.id, strategy_id: params[:id])
        end

        def auth_user
          @user = Rails.cache.fetch(request.headers[:token])
          render json: Failure.new(-1, '您还未登录') if @user.blank?
        end
      end
    end
  end
end
