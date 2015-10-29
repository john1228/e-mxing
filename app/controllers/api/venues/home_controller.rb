module Api
  module Venues
    class HomeController < ApplicationController
      def index
        venues = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
            order('distance asc').
            order(id: :desc).page(params[:page]||1)
        render json: Success.new(venues: venues)
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

      def profile
        def show
          venues = Service.find_by_mxid(params[:mxid])
          venues.update(views: venues.views + 1)
          render json: Success.new(coach: venues.detail)
        end
      end

      def tag
        render tag: Success.new(tag: [])
      end
    end
  end
end
