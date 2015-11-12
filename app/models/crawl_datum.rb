class CrawlDatum < ActiveRecord::Base
  mount_uploaders :photo_replace, PhotosUploader
end
