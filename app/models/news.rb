class News < ActiveRecord::Base
  mount_uploader :cover, NewsCoverUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        width: cover_width,
        height: cover_height,
        url: $host + "/news/#{id}"
    }
  end
end
