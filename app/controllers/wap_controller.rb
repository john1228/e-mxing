class WapController < ApplicationController
  layout 'wap'

  def index
    render layout: false
  end

  def film
    redirect_to controller: :share, action: :dynamic, id: params[:id]
  end

  def qrcode
    @qrcode = RQRCode::QRCode.new("http://github.com/", :size => 4, :level => :h)
    render layout: false
  end
end
