class Gallery < ActiveRecord::Base
  has_many :images, class_name: GalleryImage, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  validates_presence_of :tag, :images
  validates_length_of :images, minimum: 1, maximum: 6, message: '最多只能上传6张图片'

  def as_json
    images.map { |image|
      {
          thumb: image.image.thumb.url,
          original: image.image.url,
          caption: image.caption
      }
    }
  end
end
