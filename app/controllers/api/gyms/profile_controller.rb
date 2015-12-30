module Api
  module Gyms
    class ProfileController < BaseController
      def show
        render json: Success.new(coach: {
                                     mxid: @coach.profile.mxid,
                                     name: HarmoniousDictionary.clean(@coach.profile.name),
                                     avatar: @coach.profile.avatar.url,
                                     gender: @coach.profile.gender.to_i,
                                     age: @coach.profile.age,
                                     identity: @coach.profile.identity_value,
                                     tags: @coach.profile.tags,
                                     photowall: @coach.photos.map { |photo| {id: photo.id, url: photo.photo.url} },
                                     score: @coach.score,
                                     likes: @coach.likes.count,
                                     dynamics: @coach.dynamics.count,
                                     signature: @coach.profile.signature,
                                     service: {
                                         mxid: @coach.service.profile.mxid,
                                         name: @coach.service.profile.name,
                                         address: @coach.service.profile.province.to_s + @coach.service.profile.city.to_s + @coach.service.profile.address,
                                         coordinate: {
                                             lng: @coach.service.place.lonlat.x,
                                             lat: @coach.service.place.lonlat.y
                                         },
                                     },
                                     fpg: @coach.profile._fitness_program,
                                     course: {
                                         amount: Sku.online.course.where(seller_id: @coach.id).count,
                                         item: Sku.online.course.where(seller_id: @coach.id).order(updated_at: :desc).take(2)
                                     },
                                     comment: {
                                         amount: @coach.comments.count,
                                         item: @coach.comments.take(2).map { |comment|
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
                                     },
                                     contact: @coach.mobile
                                 })
      end
    end
  end
end
