class HomeController < ApplicationController
  caches_page :index, :wap, :about, :contact, :join, :detail

  def index
    ua = request.env['HTTP_USER_AGENT'].downcase
    if ua.include?('android') || ua.include?('iphone')
      redirect_to action: :wap
    else
      render layout: false
    end
  end

  def wap
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
