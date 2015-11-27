module Business
  class BaseController<ApplicationController
    before_action :verify_auth_token, except: :mobile
    private
    def verify_auth_token
      logger.info "私教登录TOKEN：#{request.headers[:token]}"
      @coach = Rails.cache.fetch("gyms-#{request.headers[:token]}")
      render json: {code: -1, message: '您还为登录'} if @coach.blank?
    end
  end
end