class Activity < ActiveRecord::Base
  mount_uploader :cover, ActivityCoverUploader
  TOP = {first: 1, second: 2, third: 3}

  def as_json
    {
        title: title,
        cover: cover.url,
        url: $host + "/activities/#{id}",
    }
  end
end
