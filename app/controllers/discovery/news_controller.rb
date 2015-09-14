module Discovery
  class NewsController < ApplicationController
    def index
      if params[:tag].present?
        render json: Success.new(news: [{
                                            tag: params[:tag],
                                            item: News.where(tag: params[:tag]).order(id: :desc).page(params[:page]||1)
                                        }])
      else
        render json: Success.new(news: News::TAG.map { |tag|
                                   {
                                       tag: tag,
                                       item: News.where(tag: tag).order(id: :desc).take(2)
                                   }
                                 })
      end
    end
  end
end
