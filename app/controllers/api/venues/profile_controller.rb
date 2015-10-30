module Api
  module Venues
    class ProfileController < ApplicationController
      def show
        venues = Service.find_by_mxid(params[:mxid])
        venues.update(views: venues.views + 1)
        render json: Success.new(coach: venues.detail)
      end
    end
  end
end