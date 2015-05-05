class TypeShow < ActiveRecord::Base
  mount_uploader :cover, ShowUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        url: $host + "/type_shows/#{id}"
    }
  end
end
