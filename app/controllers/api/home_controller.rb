module Api
  class HomeController < ApplicationController
    def index
      render json: Success.new(
                 category: Sku.online.grou
             )
    end
  end
end
