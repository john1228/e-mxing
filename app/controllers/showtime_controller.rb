class ShowtimeController < ApiController
  def index
    if @user.showtime.blank?
      render json: Failure.new('未发布视频秀')
    else
      render json: Success.new(showtime: @user.showtime)
    end
  end

  def update
    if @user.create_showtime(showtime_params)
      render json: Success.new(showtime: showtime)
    else
      render json: Failure.new('发布视频秀失败')
    end
  end

  private
  def showtime_params
    params.permit(:title, :cover, :film, :content)
  end
end
