class NewsController < ApplicationController
  def show
    @news = News.find_by(id: params[:id])
    @cc = params[:cc]
    render layout: 'news'
  end
end
