class Gallery < ActiveRecord::Base
  TAGS = %w'热门图片 廋成闪电 廋成闪电1 廋成闪电2 廋成闪电3 廋成闪电4 廋成闪电5 廋成闪电6 廋成闪电7 廋成闪电8'
  has_many :images, class_name: GalleryImage, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  validates_presence_of :tag, :images

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
