module Api
  class HomeController < ApplicationController
    def index
      render json: {

             }
    end

    def search
      render json: Success.new(
                 result: {
                     venues: [{}],
                     course: [{}],
                     knowledge: [{}],
                     user: [{}]
                 }
             )
    end
  end
end
