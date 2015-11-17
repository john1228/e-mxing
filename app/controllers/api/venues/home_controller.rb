module Api
  module Venues
    class HomeController < ApplicationController
      def index
        venues = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance")
        venues = venues.where('? = ANY (profiles.tag_1)', params[:tag]) if params[:tag].present?
        venues = venues.where(profiles: [auth: params[:auth]]) if params[:auth].present?
        venues = venues.where('profiles.name LIKE ? or profiles.address LIKE ?', "%#{params[:keyword]||''}%", "%#{params[:keyword]||''}%") if params[:keyword].present?
        render json: Success.new(venues: venues.order('distance asc').order(id: :desc).page(params[:page]||1).map { |venue|
                                   {
                                       mxid: venue.profile.mxid,
                                       name: venue.profile.name,
                                       avatar: venue.profile.avatar.url,
                                       bg: (venue.photos.first.photo.url rescue ''),
                                       address: venue.profile.province.to_s + venue.profile.city.to_s + venue.profile.address.to_s,
                                       distance: venue.attributes['distance'].to_i,
                                       coach_count: venue.coaches.count,
                                       sale: venue.courses.online.count,
                                       tags: venue.profile.tags,
                                       auth: venue.profile.auth,
                                       floor: (venue.courses.online.order(selling_price: :asc).first.selling_price rescue ''),
                                   }
                                 })
      end

      def boutique
        render json: Success.new(
                   venues: News.where('? = ANY (tag_1)', params[:tag]).page(params[:page]||1)
               )
      end
    end
  end
end
