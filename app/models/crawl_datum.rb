class CrawlDatum < ActiveRecord::Base
  mount_uploaders :photo_replace, PhotosUploader
  mount_uploader :avatar, ProfileUploader
end
