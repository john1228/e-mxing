class ApplicationController < ActionController::Base
  protect_from_forgery #with: :null_session
  $host = 'http://stage.e-mxing.com'
  $hls_host = 'http://video.e-mxing.com/hls'
  $img_host = 'http://stage.e-mxing.com/images'


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to 'http://www.e-mxing.com/admin/login'
  end


  def after_sign_in_path_for(resource_or_scope)
    admin_dashboard_path
  end


end
