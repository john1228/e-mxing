module Gyms
  class ProfilesController < BaseController
    def show
      render json: Success.new(coach: @coach.detail)
    end
  end
end
