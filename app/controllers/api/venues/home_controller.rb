module Api
  module Venues
    class HomeController < ApplicationController
      def index
        page = (params[:page]||1).to_i
        agencies = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
            where('profiles.name LIKE ? or profiles.address LIKE ?', "%#{params[:keyword]||''}%", "%#{params[:keyword]||''}%").
            # where('profiles.address LIKE ?', "%#{city}%").
            order('distance asc').
            order(id: :desc).
            page(page)
        agencies = Service.select("users.id,st_distance(places.lonlat, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").joins(:profile, :place).order('distance asc').take(3) if agencies.blank?&&page.eql?(1)
        render json: Success.new(venues: agencies)
      end

      def boutique
        render json: Success.new(
                   venues: News.where('? = ANY (tag_1)', params[:tag]).page(params[:page]||1)
               )
      end


      def profile
        def show
          venues = Service.find_by_mxid(params[:mxid])
          venues.update(views: venues.views + 1)
          render json: Success.new(coach: venues.detail)
        end
      end
    end
  end
end
