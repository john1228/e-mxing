module Discard
  class ShowtimeController < ApiController
    def show
      render json: Failure.new('还未设置视频秀')
    end
  end

end
