class Photo < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(loc: :asc).limit(8) }
  mount_uploader :photo, PhotosUploader

  def as_json
    {
        no: id,
        url: photo.url,
    }
  end
end
