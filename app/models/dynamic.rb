class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many :dynamic_images, dependent: :destroy
  has_one :dynamic_film, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :likes, -> { where('1=1') }, foreign_key: :liked_id

  accepts_nested_attributes_for :dynamic_images
  accepts_nested_attributes_for :dynamic_film

  TOP = 1

  class<<self
    def latest
      order(id: :desc).first
    end

    def top
      where(top: 1).order(id: :desc).first
    end

    def create_showtime(showtime_params)
      dynamic = new(content: showtime_params[:content], top: TOP)
      if dynamic.save
        dynamic.create_dynamic_film(title: showtime_params[:title], cover: showtime_params[:cover], film: showtime_params[:film])
      else
        false
      end
    end
  end

  def showtime_json
    {
        title: dynamic_film.title,
        film: {
            cover: $host + dynamic_film.cover.thumb.url,
            film: dynamic_film.film.hls
        },
        likes: likes.count,
        comments: dynamic_comments.count
    }
  end

  def as_json
    json_hash = {
        no: id,
        content: content || '',
        created: created_at.to_i,
        likes: likes.count,
        comments: {
            count: dynamic_comments.count,
            item: dynamic_comments.order(id: :desc).limit(2).collect { |comment| comment.as_json }
        }
    }
    json_hash = json_hash.merge({
                                    images: dynamic_images.collect { |dynamic_image|
                                      {
                                          thumb: $host + dynamic_image.image.thumb.url,
                                          original: $host + dynamic_image.image.url,
                                          width: dynamic_image.width,
                                          height: dynamic_image.height
                                      }
                                    }
                                }) unless dynamic_images.blank?
    json_hash = json_hash.merge({
                                    film: {
                                        cover: $host + dynamic_film.cover.thumb.url,
                                        film: dynamic_film.film.hls
                                    }
                                }) unless dynamic_film.blank?
    json_hash
  end


  def summary_json
    image = dynamic_images.first.image rescue nil
    image = dynamic_film.cover if image.blank? && dynamic_film.present?
    {
        content: content,
        image: image.present? ? $host + image.thumb.url : ''
    }
  end
end
