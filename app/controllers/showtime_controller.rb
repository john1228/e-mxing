class ShowtimeController < ApplicationController
  include LoginManager

  def index
    showtime = @user.dynamics.top
    if showtime.nil?
      render json: {
                 code: 0,
                 message: '未设置视频秀!'
             }
    else
      render json: {
                 code: 1,
                 data: {
                     showtime: showtime.showtime_json
                 }
             }
    end
  end

  def update
    if @user.dynamics.create_showtime(showtime_params)
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '发布视频秀失败!'
             }
    end
  end

  private
  def showtime_params
    params.permit(:title, :cover, :film, :content)
  end
end
