class GroupPhoto < ActiveRecord::Base
  belongs_to :group
  mount_uploader :photo, PhotoUploader

  def as_json
    {
        no: id,
        thumb: $host + photo.thumb.url,
        original: $host + photo.large.url
    }
  end
end
