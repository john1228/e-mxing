class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  $host = 'http://192.168.0.111' #'http://www.e-mxing.com'
  $hls_host = 'http://video.e-mxing.com/hls'
  $img_host = 'http://192.168.0.111/images'
end
