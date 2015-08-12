class Gallery < ActiveRecord::Base
  TAGS = %w'食之有胃 腰炫腹 性感电臀 汗水日记 男神女神 硬成狗 男神女神'
  has_many :images, class_name: GalleryImage, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  validates_presence_of :tag, :images
  validates_length_of :images, maximum: 6, message: '最多只能上传6张图片'

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
