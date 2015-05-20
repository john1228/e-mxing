class Photo < ActiveRecord::Base
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  def as_json
    {
        no: id,
        thumb: photo.thumb.url,
        original: photo.url
    }
  end
end
