module Discovery
  class NewsController < ApplicationController
    def index
      if params[:tag].present?
        data = [{
                    tag: params[:tag],
                    item: News.where(tag: params[:tag]).order(id: :desc).page(params[:page]||1)
                }]
      else
        data = News.tags.map { |tag, value|
          tag_data = News.send(tag.to_sym)
          {
              tag: value,
              item: tag_data.order(id: :desc).take(2)
          } if tag_data.present?
        }
      end
      data.compact!
      render json: Success.new(news: data)
    end
  end
end
