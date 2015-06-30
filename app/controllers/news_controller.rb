class NewsController < ApplicationController
  def show
    @news = News.find_by(id: params[:id])
    @cc = params[:cc]
    @created = @news.created_at.localtime.strftime('%m-%d %H:%M')
    render layout: 'news'
  end
end
