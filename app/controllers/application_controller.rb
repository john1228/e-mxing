class ApplicationController < ActionController::Base
  protect_from_forgery #with: :null_session
  $host = 'http://stage.e-mxing.com'
  $hls_host = 'http://video.e-mxing.com/hls'
  $img_host = 'http://stage.e-mxing.com/images'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "http://www.baidu.com" #(super_user? ? franchises_path : root_path), :alert => exception.message
  end


  def after_sign_in_path_for(resource_or_scope)
    if current_admin_user.is_service?
      admin_service_path(current_admin_user.service)
    elsif current_admin_user.is_cms?
      admin_news_shows_path
    else
      admin_dashboard_path
    end
  end
end
