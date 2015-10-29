module Api
  class GymsController < ApplicationController
    def index
      render json: Success.new(
                 gyms: [{

                        }]
             )
    end
  end
end
