module Api
  module Course
    module Strategies
      class HomeController < ApplicationController
        before_filter :auth_user, except: :index

        def index
          render json: Success.new(
                     strategy: Strategy.where(category: params[:category]).order(id: :desc).page(params[:page]||1).map { |strategy|
                       {
                           id: strategy.id,
                           user: {
                               mxid: strategy.user.profile.mxid,
                               name: strategy.user.profile.name,
                               avatar: strategy.user.profile.avatar.url,
                               age: strategy.user.profile.age,
                               gender: strategy.user.profile.gender.to_i,
                               identity: strategy.user.profile.identity,
                           },
                           content: strategy.content,
                           created: strategy.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                           comment: {
                               amount: strategy.comment_count,
                               item: strategy.comments.limit(3).map { |comment|
                                 {
                                     user: {
                                         mxid: comment.user.profile.mxid,
                                         name: comment.user.profile.name,
                                         avatar: comment.user.profile.avatar.url,
                                         age: comment.user.profile.age,
                                         gender: comment.user.profile.gender.to_i,
                                         identity: comment.user.profile.identity,
                                     },
                                     content: comment.content,
                                     created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                                 }
                               }
                           }
                       }
                     }
                 )
        end

        def create
          strategy = Strategy.new(strategy_params.merge(user_id: @user.id))
          if strategy.save
            render json: Success.new
          else
            render json: Failure.new('发布失败:' + strategy.errors.messages.values.join(';'))
          end
        end

        protected
        def strategy_params
          params.permit(:content, :category)
        end

        def auth_user
          @user = Rails.cache.fetch(request.headers[:token])
          render json: Failure.new(-1, '您还未登录') if @user.blank?
        end
      end
    end
  end
end
