class Category < ActiveRecord::Base
  mount_uploader :background, ImagesUploader
end
