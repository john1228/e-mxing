module Gyms
  class CoachesController < BaseController
    def show
      render json: Success.new(coach: @coach.detail)
    end
  end
end
