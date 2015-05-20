class Banner < ActiveRecord::Base
  scope :valid, -> { where("start_date<='#{Date.today}' and '#{Date.today}'<end_date") }
  mount_uploader :image, BannerUploader

  def as_json
    {
        image: image.thumb.url,
        url: url
    }
  end
end
