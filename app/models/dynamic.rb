class Dynamic < ActiveRecord::Base
  belongs_to :user
  after_save :check_images

  has_many :dynamic_images, dependent: :destroy
  has_one :dynamic_film, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :likes, -> { where(like_type: Like::DYNAMIC) }, foreign_key: :liked_id, dependent: :destroy

  accepts_nested_attributes_for :dynamic_images
  accepts_nested_attributes_for :dynamic_film
  validates_presence_of :user_id

  TOP = 1

  def as_json
    json_hash = {
        no: id,
        publisher: user.summary_json,
        content: HarmoniousDictionary.clean(content || ''),
        created: created_at.to_i,
        likes: likes.count,
        like_user: likes.includes(:user).order(id: :desc).limit(15).map { |like| like.as_json },
        comments: {
            count: dynamic_comments.count,
            item: dynamic_comments.order(id: :desc).limit(2).collect { |comment| comment.as_json }
        }
    }
    json_hash = json_hash.merge({images: dynamic_images.collect { |dynamic_image| dynamic_image.image.url }}) unless dynamic_images.blank?
    json_hash = json_hash.merge({
                                    film: {
                                        cover: dynamic_film.cover.url,
                                        film: dynamic_film.film.hls
                                    }
                                }) unless dynamic_film.blank?
    json_hash
  end


  def summary_json
    image = dynamic_images.first.image rescue nil
    image = dynamic_film.cover if image.blank? && dynamic_film.present?
    {
        content: HarmoniousDictionary.clean(content||''),
        image: image.present? ? image.url : ''
    }
  end
end
