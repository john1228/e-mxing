module CoachesManager
  extend ActiveSupport::Concern

  included do
    before_action :verify_coach, only: :index
    before_action :verify_auth_token, :create, :update, :destroy
  end

  private
  def verify_coach
    @coach = Coach.find_by_mxid(params[:mxid])
    render json: {
               code: 0,
               message: '您查看到教练不存在'
           } if @coach.blank?
  end

end
