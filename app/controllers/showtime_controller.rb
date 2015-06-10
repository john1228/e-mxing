class ShowtimeController < ApiController
  def index
    user = User.find_by_mxid(params[:mxid])
    if user.blank?
      render json: Failure.new('您查看到用户不存在')
    else
      if user.showtime.blank?
        render json: Failure.new('未发布视频秀')
      else
        render json: Success.new(showtime: showtime)
      end
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
