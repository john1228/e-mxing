module Discovery
  class DynamicsController < ApplicationController
    def index
      render json: Success.new(dynamic: Dynamic.order(id: :desc).includes(:user).page(params[:page]||1).map { |dynamic|
                                 {
                                     id: dynamic.id,
                                     content: HarmoniousDictionary.clean(dynamic.content || ''),
                                     image: dynamic.dynamic_images.map { |image| {url: image.image.url} },
                                     film: {cover: (dynamic.dynamic_film.cover.url rescue ''), film: (dynamic.dynamic_film.film.hls rescue '')},
                                     created: dynamic.created_at.to_i,
                                     publisher: {
                                         mxid: dynamic.user.profile.mxid,
                                         name: dynamic.user.profile.name,
                                         avatar: dynamic.user.profile.avatar.url,
                                         age: dynamic.user.profile.age,
                                         gender: dynamic.user.profile.gender,
                                         identity: Profile.identities[dynamic.user.profile.identity]
                                     },
                                     likes: dynamic.likes.count,
                                     like_user: dynamic.likes.includes(:user).order(id: :desc).limit(15).map { |like| {
                                         user: {
                                             mxid: like.user.profile.mxid,
                                             name: like.user.profile.name,
                                             avatar: like.user.profile.avatar.url,
                                             age: like.user.profile.age,
                                             gender: like.user.profile.gender,
                                             identity: Profile.identities[like.user.profile.identity]
                                         },
                                         created: like.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                                     } },
                                     comments: {
                                         count: dynamic.dynamic_comments.count,
                                         item: dynamic.dynamic_comments.order(id: :desc).limit(2).collect { |comment|
                                           {
                                               content: HarmoniousDictionary.clean(comment.content),
                                               created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                                               user: {
                                                   mxid: comment.user.profile.mxid,
                                                   name: comment.user.profile.name,
                                                   avatar: comment.user.profile.avatar.url,
                                                   age: comment.user.profile.age,
                                                   gender: comment.user.profile.gender,
                                                   identity: Profile.identities[comment.user.profile.identity]
                                               },
                                           }
                                         }
                                     }
                                 }
                               })
    end
  end
end
