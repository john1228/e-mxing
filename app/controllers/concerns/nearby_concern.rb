module NearbyConcern
  extend ActiveSupport::Concern

  included do
    before_action :need_user, only: :upload
  end

  def need_user
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {
               code: 0,
               message: '您还未登录！',
           } if @user.nil?
  end
end
