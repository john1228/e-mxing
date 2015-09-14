class News < ActiveRecord::Base
  TAG = %w'训练课 饮食控 私教 机构'
  mount_uploader :cover, NewsCoverUploader


  def as_json
    {
        title: title,
        cover: cover.thumb.url,
        width: cover_width,
        height: cover_height,
        content: content[0, 200],
        url: $host + "/news/#{id}"
    }
  end
end
