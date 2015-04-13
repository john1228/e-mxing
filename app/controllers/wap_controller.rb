class WapController < ApplicationController
  layout 'wap'

  def index
  end

  def film
    @film = Film.find_by(id: params[:id])
    @actor = @film.dynamic.user.profile
  end

  def course
    @course = Course.find_by(id: params[:id])
    @actor = Profile.find_by(user_id: @course.user_id)
    latest_schedule = Schedule.where(course_id: @course.id).last
    @latester = latest_schedule.nil? ? nil : Profile.find_by(user_id: latest_schedule.user_id)
  end
end
