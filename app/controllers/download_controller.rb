class DownloadController < ApplicationController
  def index
    ua = request.env['HTTP_USER_AGENT']
    if ua.include?('iPhone')||ua.includes?('iPod')||ua.includes?('iPad')
      redirect_to 'https://itunes.apple.com/app/id937987572'
    elsif ua.include?('android')||ua.include?('Android')
      send_file("#{Rails.root}/public/apk/e-mxing.apk")
    else
      render text: '未知来源'
    end
  end

  def internal
    ua = request.env['HTTP_USER_AGENT']
    if ua.include?('iPhone')||ua.includes?('iPod')||ua.includes?('iPad')
      redirect_to 'https://itunes.apple.com/app/id937987572'
    elsif ua.include?('android')||ua.include?('Android')
      send_file("#{Rails.root}/public/apk/e-mxing.apk")
    else
      render text: '未知来源'
    end
  end
end
