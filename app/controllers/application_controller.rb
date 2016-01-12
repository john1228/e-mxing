class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  $host = 'http://stage.e-mxing.com'
  $hls_host = 'http://video.e-mxing.com/hls'
  $img_host = 'http://stage.e-mxing.com/images'

  def access_denied(exception)
    redirect_to new_admin_user_session_path, :alert => exception.message
  end

  def after_sign_in_path_for(admin_user)
    if admin_user.store_manager?
      admin_service_path(Service.find_by(id: admin_user.service_id))
    else
      admin_dashboard_path
    end
  end
end
