class Category < ActiveRecord::Base
  mount_uploader :background, PhotosUploader
end
