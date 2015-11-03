module Api
  module Venues
    class ProfileController < ApplicationController
      def show
        venue = Service.find_by_mxid(params[:mxid])
        venue.update(views: venue.views + 1)
        render json: Success.new(venues: {
                                     mxid: venue.profile.mxid,
                                     name: venue.profile.name,
                                     avatar: venue.profile.avatar.url,
                                     views: views,
                                     address: venue.profile.province.to_s + venue.profile.city.to_s + venue.profile.address.to_s,
                                     coordinate: {
                                         lng: venue.place.lonlat.x,
                                         lat: venue.place.lonlat.y
                                     },
                                     intro: venue.profile.signature,
                                     coach: {
                                         amount: venue.coaches.count,
                                         item: venue.coaches.map { |coach|
                                           coach.summary_json.merge(likes: coach.likes.count)
                                         }
                                     },
                                     dynamics: venue.dynamics.count,
                                     course: {
                                         amount: venue.courses.online.count,
                                         item: venue.courses.online.order(updated_at: :desc).take(2)
                                     },
                                     open: '8:30-21:30',
                                     service: (INTERESTS['items'].map { |item| item['name'] if venue.profile.hobby.include?(item['id']) }.compact! rescue []),
                                     facility: venue.profile.service,
                                     contact: venue.profile.mobile,
                                     photowall: venue.photos.map { |photo| {url: photo.photo.url} }
                                 })
      end
    end
  end
end