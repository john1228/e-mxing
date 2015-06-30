class NewsController < ApplicationController
  def show
    @news = News.find_by(id: params[:id])
    @cc = params[:cc]
    @created = @news.created_at.localtime.strftime('%m-%d %H:%M')
    logger.info "新闻时间:#{@created}"
    render layout: 'news'
  end
end
