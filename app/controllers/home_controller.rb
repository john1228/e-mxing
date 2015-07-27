class HomeController < ApplicationController
  layout 'home'

  def index
    @qr_img = RQRCode::QRCode.new('https://github.com/whomwah/rqrcode', :size => 4, :level => :h).to_img
  end

  def about

  end

  def dynamic

  end

  def contact

  end

  def join

  end
end
