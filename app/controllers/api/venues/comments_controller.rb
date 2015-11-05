module Gyms
  class CommentsController < ApplicationController
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
                                             identity: comment.user.profile.identiy,
                                         },
                                         content: comment.content,
                                         image: comment.image.map { |image| image.url },
                                         created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                                     }
                                   }
                               })
    end

    def latest
      venue = Service.find_by_mxid(params[:mxid])
      comments = VenueComment.where(venue_id: venue.id)
      render json: Success.new({
                                   count: comments.count,
                                   item: comments.order(id: :desc).limit(2).map { |comment|
                                     {
                                         user: {
                                             mxid: comment.user.profile.mxid,
                                             name: comment.user.profile.name,
                                             avatar: comment.user.profile.avatar.url,
                                             age: comment.user.profile.age,
                                             gender: comment.user.profile.gender.to_i,
                                             identity: comment.user.profile.identiy,
                                         },
                                         content: comment.content,
                                         image: comment.image.map { |image| image.url },
                                         created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                                     }
                                   }
                               })
    end

    def create
      venue = Service.find_by_mxid(params[:mxid])
      comment = VenueComment.new(venue_comment_params.merge(venue_id: venue.id))
      if comment.save
        render json: Success.new
      else
        render json: Failure.new('评论失败: '+ comment.errors.messages.values.join(';'))
      end
    end

    private
    def venue_comment_params
      params.permit(:content, :score, image: [])
    end
  end
end
