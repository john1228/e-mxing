module CheckConcern
  extend ActiveSupport::Concern

  included do
    before_action :find_user, only: :index
    before_action :need_user, only: [:create, :update, :destroy, :appoint, :latest, :upload]
    before_action :fetch_mobile, only: :complete
  end

  private
  def find_user
    profile = Profile.find_by_mxid(params[:mxid])
    if profile.nil?
      render json: {
                 code: 0,
                 message: '没有该用户',
             }
    else
      @user = profile.user
    end
  end

  def need_user
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {
               code: 0,
               message: '您还未登录'
           } if @user.nil?
  end

  def fetch_mobile
    @mobile = Rails.cache.fetch(request.headers[:token])
    render json: {
               code: 0,
               message: '您到注册信息已过期,请重新注册'
           } if @mobile.nil?
  end
end
