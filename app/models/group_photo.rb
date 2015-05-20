class GroupPhoto < ActiveRecord::Base
  belongs_to :group
  mount_uploader :photo, PhotoUploader

  def as_json
    {
        no: id,
        thumb: photo.thumb.url,
        original: photo.large.url
    }
  end
end
