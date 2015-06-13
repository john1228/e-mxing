module Business
  class BaseController<ApplicationController
    before_action :verify_auth_token, except: :mobile
    private
    def verify_auth_token
      logger.info "私教TOKEN#{request.headers[:token]}"
      @coach = Rails.cache.fetch("#{request.headers[:token]}|gyms")
      render json: {code: 0, message: '您还为登录'} if @coach.blank?
    end
  end
end