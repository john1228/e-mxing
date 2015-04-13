class Photo < ActiveRecord::Base
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  def as_json
    {
        no: id,
        thumb: $host + photo.thumb.url,
        original: $host + photo.url
    }
  end
end
