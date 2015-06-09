class VersionController < ApplicationController
  def index
    render json: Success.new({})
  end
end
