class ActivitiesController < ApplicationController
  def show
    @activity = Activity.find_by(id: params[:id])
    @group = Group.find_by(id: @activity.group_id)
    render layout: 'activity'
  end
end
