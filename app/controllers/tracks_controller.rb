class TracksController < ApplicationController
  include LoginManager

  def index
    require_date = Date.parse(params[:date]) rescue Date.today
    render json: {
               code: 1,
               data: {
                   tracks: @user.tracks.where(start: require_date...require_date.tomorrow).collect { |track|
                     track.summary_json
                   }
               }
           }
  end

  def show
    track = Track.find_by(id: params[:id])
    if track.nil?
      render json: {
                 code: 0,
                 message: '您查看到运动轨迹已删除'
             }
    else
      render json: {
                 code: 1,
                 data: {
                     track: track.as_json
                 }
             }
    end
  end

  def create
    track = @user.tracks.new(track_params)
    if track.save
      render json: {
                 code: 1
             }
    else
      logger.info track.errors.messages
      render json: {
                 code: 0,
                 message: '发布运动轨迹失败'
             }
    end
  end

  def update
    track = @user.tracks.find_by(id: params[:id])
    if track.present?&&track.update(track_params)
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '更新运动轨迹失败'
             }
    end

  end

  def destroy

  end


  def appoint
    appointment = @user.appointments.new(track_id: params[:id])
    if appointment.save
      render json: {
                 code: 1
             }
    else
      render json: {
                 code: 0,
                 message: '预约失败'
             }
    end
  end

  private
  def track_params
    params.permit(:type, :name, :start, :during, :intro, :address, :avail, :free)
  end
end
