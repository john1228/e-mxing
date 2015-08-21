class WapController < ApplicationController
  layout 'wap'

  def index
    render layout: false
  end

  def film
    @dynamic= Dynamic.find_by(id: params[:id])
    @actor = @dynamic.user.profile
  end
end
