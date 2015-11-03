class Tag < ActiveRecord::Base
  enum tag: [:venues, :course, :dynamic, :news]
  mount_uploader :background, ImagesUploader
end