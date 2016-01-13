module Business
  class BaseController<ApplicationController
    before_filter :verify_auth_token, except: [:mxing, :alipay]
    private
    def verify_auth_token
      logger.info request.to_json
      @coach = Rails.cache.fetch("gyms-#{request.headers[:token]}")
      render json: {code: -1, message: '您还为登录'} if @coach.blank?
    end
  end
end