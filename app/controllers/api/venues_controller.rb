module Api
  class VenuesController < ApplicationController
    def index
      tag = params[:tag]
      auth = params[:auth]
      keyword = params[:keyword]
      render json: Success.new(
                 venues: [{
                          }]
             )
    end

    def boutique
      render json: Success.new(
                 venues: [{
                          }]
             )
    end


    def profile
      service = Service.find_by_mxid(params[:mxid])
      render json: Success.new(
                 venues: service.detail
             )
    end
  end
end
