module Discovery
  class ImagesController < ApplicationController
    def index
      if params[:tag].present?
        render json: Success.new(image: tag_image(params[:tag]))
      else
        render json: Success.new(image: all_image)
      end
    end

    private

    def tag_image(tag)
      [{
           tag: tag,
           item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).uniq.order(id: :desc).page(params[:page]||1).map { |dynamic|
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
                     identity: dynamic.user.profile.identity_value
                 },
                 likes: dynamic.likes.count,
                 like_user: dynamic.likes.includes(:user).order(id: :desc).limit(15).map { |like| {
                     user: {
                         mxid: like.user.profile.mxid,
                         name: like.user.profile.name,
                         avatar: like.user.profile.avatar.url,
                         age: like.user.profile.age,
                         gender: like.user.profile.gender,
                         identity: like.user.profile.identity_value
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
                               identity: comment.user.profile.identity_value
                           },
                       }
                     }
                 }
             }
           }
       }]
    end

    def all_image
      data = Tag.dynamics.pluck(:name).map { |tag|
        {
            tag: tag,
            item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).uniq.order(id: :desc).take(3).map { |dynamic|
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
                      identity: dynamic.user.profile.identity_value
                  },
                  likes: dynamic.likes.count,
                  like_user: dynamic.likes.includes(:user).order(id: :desc).limit(15).map { |like| {
                      user: {
                          mxid: like.user.profile.mxid,
                          name: like.user.profile.name,
                          avatar: like.user.profile.avatar.url,
                          age: like.user.profile.age,
                          gender: like.user.profile.gender,
                          identity: like.user.profile.identity_value
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
                                identity: comment.user.profile.identity_value
                            },
                        }
                      }
                  }
              } }
        } if Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).present?
      }
      data.compact!
      data
    end
  end
end
