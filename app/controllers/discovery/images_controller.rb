module Discovery
  class ImagesController < ApplicationController
    def index
      if params[:tag].present?
        render json: Success.new(news: [{
                                            tag: params[:tag],
                                            item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', params[:tag]).uniq.order(id: :desc).page(params[:page]||1).map { |item|
                                              item.as_json.merge(user: item.user.profile.summary_json)
                                            }
                                        }])
      else
        render json: Success.new(news: TAGS.map { |tag|
                                   {
                                       tag: tag,
                                       item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).uniq.order(id: :desc).take(3).map { |item|
                                         item.as_json.merge(user: item.user.profile.summary_json)
                                       }
                                   }
                                 })
      end
    end
  end
end
