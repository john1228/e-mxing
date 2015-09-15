module Agency
  class ProfilesController < BaseController
    def show
      render json: Success.new(coach: @agency.detail)
    end
  end
end
