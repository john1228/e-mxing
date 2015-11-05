module Mine
  class LikesController < BaseController
    def most
      render json: Success.new(
                 like: Like.select('likes.user_id,count(*) as like_count').
                     where(liked_id: @user.id,).group(:user_id).
                     order('like_count desc').page(params[:page]||1).map { |like|
                   {
                       user: {
                           mxid: like.user.profile.mxid,
                           name: like.user.profile.name,
                           avatar: like.user.profile.avatar.url,
                           age: like.user.profile.age,
                           gender: like.user.profile.gender,
                           identity: Profile.identities[like.user.profile.identity]
                       },
                       count: like.attributes['like_count']
                   }
                 }
             )
    end

    def latest
      render json: Success.new(
                 like: Like.person.order(id: :desc).map { |like|
                   {
                       user: {
                           mxid: like.user.profile.mxid,
                           name: like.user.profile.name,
                           avatar: like.user.profile.avatar.url,
                           age: like.user.profile.age,
                           gender: like.user.profile.gender,
                           identity: Profile.identities[like.user.profile.identity]
                       },
                       created: like.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
                 }
             )
    end
  end
end
