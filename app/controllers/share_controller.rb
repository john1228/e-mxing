class ShareController < ApplicationController
  def dynamic
    @dynamic = Dynamic.find_by(id: params[:id])
    @user = @dynamic.user
    seconds = Time.now - @dynamic.created_at
    if seconds <60
      @created_string = '刚刚'
    elsif seconds< 60*60
      @created_string = "#{(seconds/60).to_i}分钟"
    elsif seconds< 60*60*24
      @created_string = "#{(seconds/(60*60)).to_i}小时前"
    elsif seconds < 60*60*24*7
      @created_string = "#{(seconds/(60*60*24)).to_i}天前"
    elsif seconds< 60*60*24*30
      @created_string = "#{(seconds/(60*60*24*7)).to_i}周前"
    elsif seconds < 60*60*24*365
      @created_string = "#{(seconds/(60*60*24*30)).to_i}月前"
    else
      @created_string = "#{(seconds/(60*60*24*365)).to_i}年前"
    end
    @dynamic_film = @dynamic.dynamic_film
    @dynamic_images = @dynamic.dynamic_images
    @comments = @dynamic.dynamic_comments
    render layout: false
  end

  def service
    @service = Service.find_by_mxid(params[:id])
    @coaches = @service.coaches.take(8)
    @photos = @service.service_photos.order(id: :desc).take(8)
    @courses = Course.where(status: Course::STATUS[:online], coach_id: @service.coaches.pluck(:id)).take(4)
    render layout: false
  end
end
