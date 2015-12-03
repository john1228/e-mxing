module Business
  class CoursesController < BaseController
    def index
      student = User.find_by_mxid(params[:mxid])
      render json: Success.new
    end
  end
end