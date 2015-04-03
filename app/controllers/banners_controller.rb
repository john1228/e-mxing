class BannersController < ApplicationController
  def index
    render json: {
               code: 1,
               data: Banner.all.collect { |banner| banner.as_json }
           }
  end
end
