class News < ActiveRecord::Base
  mount_uploader :cover, NewsCoverUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        url: url
    }
  end
end
