class WapController < ApplicationController
  layout 'wap'

  def index
    logger.info "请求报文体：#{JSON.parse(request.body)}"
  end

  def film
    @dynamic= Dynamic.find_by(id: params[:id])
    @actor = @dynamic.user.profile
  end
end
