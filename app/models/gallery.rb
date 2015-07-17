class Gallery < ActiveRecord::Base
  TAGS = %w'热门图片 廋成闪电'
  has_many :images, class_name: GalleryImage, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  def as_json
    images.map { |image|
      {
          thumb: image.image.thumb.url,
          original: image.image.url
      }
    }
  end
end
