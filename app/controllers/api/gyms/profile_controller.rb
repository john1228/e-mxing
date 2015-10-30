module Api
  module Gyms
    class ProfileController < BaseController
      def show
        render json: Success.new(coach: @coach.detail)
      end
    end
  end
end
