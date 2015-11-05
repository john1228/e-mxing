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
                                     photowall: @coach.photos.map { |photo| {url: photo.photo.url} },
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
                                     fpg: _fitness_program,
                                     course: {
                                         amount: Sku.online.where(seller_id: @coach.id).count,
                                         item: Sku.online.where(seller_id: @coach.id).order(updated_at: :desc).take(2)
                                     },
                                     comment: {
                                         amount: @coach.comments.count,
                                         item: @coach.comments.take(2)
                                     },
                                     contact: @coach.mobile
                                 })
      end
    end
  end
end
