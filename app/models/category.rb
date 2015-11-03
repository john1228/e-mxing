class Category < ActiveRecord::Base
  mount_uploader :background, PhotosController
end
