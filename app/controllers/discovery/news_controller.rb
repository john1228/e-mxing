module Discovery
  class NewsController < ApplicationController
    def index
      if params[:tag].present?
        data = [{
                    tag: params[:tag],
                    item: News.where(tag: params[:tag]).order(id: :desc).page(params[:page]||1)
                }]
      else
        data = News::TAG.map { |tag|
          {
              tag: tag,
              item: News.where(tag: tag).order(id: :desc).take(2)
          } if News.where(tag: tag).present?
        }
      end
      data.delete(nil)
      render json: Success.new(news: data)
    end
  end
end
