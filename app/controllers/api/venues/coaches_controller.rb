module Api
  module Venues
    class CoachesController < ApplicationController
      def index
        service = Service.find_by_mxid(params[:mxid].to_i)
        render json: {
                   code: 1,
                   data: {
                       coaches: service.coaches.map { |coach|
                         coach.summary_json
                       }
                   }
               }
      end
    end
  end
end
