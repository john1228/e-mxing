module Api
  module Venues
    class CommentsController < ApplicationController
      before_filter :auth_user, only: :create
      #私教评论列表
      def index
        venue = Service.find_by_mxid(params[:mxid])
        comments = VenueComment.where(venue_id: venue.id)
        render json: Success.new({
                                     item: comments.order(id: :desc).page(params[:page]||1).map { |comment|
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
                                           images: comment.image.map { |image| image.url },
                                           created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                                       }
                                     }
                                 })
      end

      def latest
        venue = Service.find_by_mxid(params[:mxid])
        comments = VenueComment.where(venue_id: venue.id)
        render json: Success.new({
                                     amount: comments.count,
                                     item: comments.order(id: :desc).limit(2).map { |comment|
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
                                           images: comment.image.map { |image| image.url },
                                           created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                                       }
                                     }
                                 })
      end

      def create
        comment = VenueComment.new(venue_comment_params)
        if comment.save
          render json: Success.new
        else
          render json: Failure.new('评论失败: '+ comment.errors.messages.values.join(';'))
        end
      end

      private
      def venue_comment_params
        venue = Service.find_by_mxid(params[:mxid])
        permit_params = params.permit(:content, :score)
        permit_params.merge(user_id: @user.id, venue_id: venue.id, image: (0..8).map { |index| params[index.to_s.to_sym] if params[index.to_s.to_sym].present? }.compact!)
      end

      def auth_user
        @user = Rails.cache.fetch(request.headers[:token])
        render json: Failure.new(-1, '您还未登录') if @user.blank?
      end
    end
  end
end
