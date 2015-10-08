module Agency
  class ProfilesController < BaseController
    def show
      @agency.update(views: @agency.views + 1)
      render json: Success.new(coach: @agency.detail)
    end
  end
end
