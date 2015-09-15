module Fan
  class ProfilesController < BaseController
    def show
      render json: Success.new(enthusiast: @enthusiast.detail)
    end
  end
end
