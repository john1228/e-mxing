module Api
  module Venues
    class HomeController < ApplicationController
      def index
        venues = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
            order('distance asc').
            order(id: :desc).page(params[:page]||1)
        render json: Success.new(venues: venues.map { |venue|
                                   {
                                       mxid: venue.profile.mxid,
                                       name: venue.profile.name,
                                       avatar: venue.profile.avatar,
                                       background: (venue.photos.first.photo.url rescue ''),
                                       address: venue.profile.province.to_s + venue.profile.city.to_s + venue.profile.address.to_s,
                                       distance: venue.attributes['distance'].to_i,
                                       coach: venue.coaches.count,
                                       sale: venue.courses.online.count,
                                       tag: tag,
                                       auth: auth
                                   }
                                 })
      end

      def boutique
        render json: Success.new(
                   venues: News.where('? = ANY (tag_1)', params[:tag]).page(params[:page]||1)
               )
      end

      def search
        venues = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
            where('profiles.name LIKE ? or profiles.address LIKE ?', "%#{params[:keyword]||''}%", "%#{params[:keyword]||''}%")
        venues.where('? = ANY (profiles.tag_1)', params[:tag]) if params[:tag].present?
        venues.where(profiles: [auth: params[:auth]]) if params[:auth].present?
        render json: Success.new(venues: venues.order('distance asc').order(id: :desc).page(params[:page]||1))
      end

      def tag
        render tag: Success.new(tag: [])
      end
    end
  end
end
