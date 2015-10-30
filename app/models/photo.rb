class Photo < ActiveRecord::Base
  default_scope -> { limit(8) }
  belongs_to :user
  mount_uploader :photo, PhotosUploader

  def as_json
    {
        no: id,
        url: photo.url,
    }
  end
end
