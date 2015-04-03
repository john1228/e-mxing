class Activity < ActiveRecord::Base
  mount_uploader :cover, ActivityCoverUploader

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        address: address,
        time: time,
        url: url
    }
  end
end
