class ActivitiesController < ApplicationController
  def show
    @activity = Activity.find_by(id: params[:id])
    @group = Group.find_by(id: @activity.group_id)
    @token = request.headers[:token]||"default"
    render layout: 'activity'
  end

  def apply
    user = User.first
    activity = Activity.find_by(id: params[:id])
    apply = activity.applies.new(user_id: user.id)
    if apply.save
      render json: {code: 1}
    else
      render json: {code: 0}
    end
  end

  def mine

  end
end
