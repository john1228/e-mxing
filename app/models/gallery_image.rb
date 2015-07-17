class GalleryImage < ActiveRecord::Base
  mount_uploader :image, GalleryUploader
end
