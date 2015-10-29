module Api
  class CoursesController < ApplicationController
    def index
      render json: Success.new(
                 course: [{
                          }]
             )
    end
  end
end
