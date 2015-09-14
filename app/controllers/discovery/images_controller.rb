module Discovery
  class ImagesController < ApplicationController
    def index
      if params[:tag].present?
        render json: Success.new(news: [{
                                            tag: params[:tag],
                                            item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', params[:tag]).uniq.order(id: :desc).page(params[:page]||1)
                                        }])
      else
        render json: Success.new(news: TAGS.map { |tag|
                                   {
                                       tag: tag,
                                       item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).uniq.order(id: :desc).take(3)
                                   }
                                 })
      end
    end
  end
end
