module Business
  class BaseController<ApplicationController
    before_filter :verify_auth_token
    private
    def verify_auth_token
      @coach = Rails.cache.fetch("gyms-#{request.headers[:token]}")
      render json: {code: -1, message: '您还为登录'} if @coach.blank?
    end
  end
end