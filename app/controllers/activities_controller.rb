class ActivitiesController < ApiController
  before_action :verify_auth_token, only: [:apply, :mine]

  def show
    @activity = Activity.find_by(id: params[:id])
    @group = Group.find_by(id: @activity.group_id)
    @token = request.headers[:token]||''
    @cc = params[:cc]
    render layout: 'activity'
  end

  def apply
    activity = Activity.find_by(id: params[:id])
    apply = activity.applies.new(user_id: @user.id)
    if apply.save
      render json: {code: 1}
    else
      render json: {code: 0}
    end
  end

  def mine
    render json: {
               code: 1,
               data: {
                   activities: @user.applies.collect { |apply|
                     apply.activity.as_json
                   }
               }
           }
  end

  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '您还未登录'} if @user.nil?
  end
end
