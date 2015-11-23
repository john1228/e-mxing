module Api
  module Venues
    class CoachesController < ApplicationController
      def index
        service = Service.find_by_mxid(params[:mxid].to_i)
        render json: {
                   code: 1,
                   data: {
                       coaches: service.coaches.page(params[:page]||1).map { |coach|
                         coach.summary_json.merge(likes: coach.likes.count)
                       }
                   }
               }
      end
    end
  end
end
