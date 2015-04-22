class NewsController < ApplicationController
  def show
    @news = News.find_by(id: params[:id])
    render layout: 'news'
  end
end
