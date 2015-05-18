class TypeShow < ActiveRecord::Base
  mount_uploader :cover, ShowUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        url: $host + "/type_shows/#{id}",
        created_at: created_at.to_i
    }
  end
end
