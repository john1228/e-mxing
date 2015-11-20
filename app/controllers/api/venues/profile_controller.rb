module Api
  module Venues
    class ProfileController < ApplicationController
      def show
        venue = Service.find_by_mxid(params[:mxid])
        if venue.present?
          venue.update(views: venue.views + 1)
          render json: Success.new(venues: {
                                       mxid: venue.profile.mxid,
                                       name: venue.profile.name,
                                       avatar: venue.profile.avatar.url,
                                       views: venue.views,
                                       address: venue.profile.province.to_s + venue.profile.city.to_s + venue.profile.address.to_s,
                                       coordinate: {
                                           lng: venue.place.lonlat.x,
                                           lat: venue.place.lonlat.y
                                       },
                                       identity: venue.profile.identity_value,
                                       tags: venue.profile.tags,
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
                                       fpg: venue.profile._fitness_program,
                                       facility: venue.profile.service,
                                       contact: venue.profile.mobile,
                                       photowall: venue.photos.map { |photo| {id: photo.id, url: photo.photo.url} }
                                   })
        else
          render json: Failure.new('您查看的场地不存在')
        end
      end
    end
  end
end