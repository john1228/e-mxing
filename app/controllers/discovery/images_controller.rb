module Find
  class NewsController < ApplicationController
    def index
      if params[:tag].present?
        render json: Success.new(news: [{
                                            tag: params[:tag],
                                            item: News.where(tag: tag).order(id: :desc).page(params[:page]||1).map{|news|
                                              {
                                                title: news.title,
                                                cover: news.cover.url,
                                                content: news.content[4,new.content.index('</p>')]
                                              }
                                            }
                                        }])
      else
        render json: Success.new(news: News::TAG.map { |tag|
                                   {
                                       tag: tag,
                                       item: News.where(tag: tag).order(id: :desc).take(2).map{|news|
                                          {
                                            title: news.title,
                                            cover: news.cover.url,
                                            content: news.content[4,new.content.index('</p>')]
                                          }
                                       }
                                   }
                                 })
      end
    end
  end
end
