module Api
  module Dynamic
    class HomeController < ApplicationController
      def index
        render json: Success.new(
                   dynamic: []
               )
      end
    end
  end
end
