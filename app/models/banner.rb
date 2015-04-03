class Banner < ActiveRecord::Base
  mount_uploader :image, BannerUploader

  def as_json
    {
        image: $host + image.thumb.url,
        url: url
    }
  end
end
