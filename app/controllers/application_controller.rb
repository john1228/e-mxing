class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  $host = 'http://stage.e-mxing.com'
  $hls_host = 'http://video.e-mxing.com/hls'
  $img_host = 'http://stage.e-mxing.com/images'

  def access_denied(exception)
    redirect_to new_admin_user_session_path, :alert => exception.message
  end
end
