module Discovery
  class ImagesController < ApplicationController
    def index
      if params[:tag].present?
        render json: Success.new(news: tag_image(params[:tag]))
      else
        render json: Success.new(news: all_image)
      end
    end

    private

    def tag_image(tag)
      [{
           tag: tag,
           item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).uniq.order(id: :desc).page(params[:page]||1).map { |item|
             item.as_json.merge(user: item.user.profile.summary_json)
           }
       }]
    end

    def all_image
      data = Tag.dynamics.map { |tag|
        {
            tag: tag,
            item: Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).uniq.order(id: :desc).take(3).map { |item|
              item.as_json.merge(user: item.user.profile.summary_json)
            }
        } if Dynamic.joins(:dynamic_images).where('? = ANY (dynamic_images.tag)', tag).present?
      }
      data.compact!
    end
  end
end
