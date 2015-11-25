module Discovery
  class NewsController < ApplicationController
    def index
      if params[:tag].present?
        data = [{
                    tag: params[:tag],
                    item: News.where('? = ANY(tag_1)', params[:tag]).order(id: :desc).page(params[:page]||1)
                }]
      else
        data = Tag.news.order(updated_at: :desc).pluck(:name).map { |tag|
          tag_data = News.where('? = ANY(tag_1)', tag)
          {
              tag: tag,
              item: tag_data.order(id: :desc).take(2)
          } if tag_data.present?
        }
        data.compact!
      end
      render json: Success.new(news: data)
    end
  end
end
