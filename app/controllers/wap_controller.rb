class WapController < ApplicationController
  layout 'wap'

  def index
    render layout: false
  end

  def film
    redirect_to controller: :share, action: :dynamic, id: params[:id]
  end
end
