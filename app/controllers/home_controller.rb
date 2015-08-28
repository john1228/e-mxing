class HomeController < ApplicationController

  def index
    ua = request.env['HTTP_USER_AGENT'].downcase
    @wap = true if ua.include?('android') || ua.include?('iphone')
    render layout: false
  end

  def about
    render layout: false
  end

  def dynamic
    @type_shows = TypeShow.order(id: :desc).take(10)
    render layout: false
  end

  def contact
    render layout: false
  end

  def join
    render layout: false
  end

  def detail
    render layout: false
  end
end
