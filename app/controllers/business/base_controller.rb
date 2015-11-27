module Business
  class BaseController<ApplicationController
    before_action :verify_auth_token, except: :mobile
    private
    def verify_auth_token
      @coach = Rails.cache.fetch("gyms-#{coach.token}")
      render json: {code: -1, message: '您还为登录'} if @coach.blank?
    end
  end
end