class ShowtimeController < ApiController
  def index
    showtime = @user.showtime
    if showtime.nil?
      render json: Failure.new('未设置视频秀')
    else
      render json: Success.new({showtime: showtime})
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
