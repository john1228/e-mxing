class DownloadController < ApplicationController
  def index
    package = params[:package]
    ua = request.env['HTTP_USER_AGENT'].downcase
    if package.eql?('b')
      if ua.include?('micromessenger')
        redirect_to 'https://51.emxing.sinaapp.com'
      elsif ua.include?('iphone')||ua.include?('ipod')||ua.include?('ipad')
        redirect_to 'https://51.emxing.sinaapp.com'
      else
        send_file("#{Rails.root}/public/apk/e-mxing-b.apk")
      end
    elsif package.eql?('c')
      if ua.include?('micromessenger')
        redirect_to 'http://a.app.qq.com/o/simple.jsp?pkgname=com.example.mx_app'
      elsif ua.include?('iphone')||ua.include?('ipod')||ua.include?('ipad')
        redirect_to 'https://itunes.apple.com/app/id937987572'
      elsif ua.include?('android')||ua.include?('android')
        send_file("#{Rails.root}/public/apk/e-mxing-c.apk")
      end
    else
      if ua.include?('micromessenger')
        redirect_to 'http://a.app.qq.com/o/simple.jsp?pkgname=com.example.mx_app'
      elsif ua.include?('iphone')||ua.include?('ipod')||ua.include?('ipad')
        redirect_to 'https://itunes.apple.com/app/id937987572'
      elsif ua.include?('android')||ua.include?('android')
        send_file("#{Rails.root}/public/apk/e-mxing.apk")
      end
    end


  end

  def internal
    ua = request.env['HTTP_USER_AGENT']
    if ua.include?('iPhone')||ua.include?('iPod')||ua.include?('iPad')
      redirect_to 'https://itunes.apple.com/app/id937987572'
    elsif ua.include?('android')||ua.include?('Android')
      send_file("#{Rails.root}/public/apk/e-mxing.apk")
    else
      render text: '未知来源'
    end
  end
end
