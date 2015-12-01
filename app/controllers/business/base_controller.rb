module Business
  class BaseController<ApplicationController
    before_filter :verify_auth_token
    private
    def verify_auth_token
      logger.info "私教登录TOKEN：#{request.headers[:token]}"
      @coach = Rails.cache.fetch("gyms-#{request.headers[:token]}")
      render json: {code: -1, message: '您还为登录'} if @coach.blank?
    end
  end
end