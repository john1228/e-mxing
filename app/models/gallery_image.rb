class GalleryImage < ActiveRecord::Base
  belongs_to :gallery
  validates_associated :gallery
  mount_uploader :image, GalleryUploader
end
