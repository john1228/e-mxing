class Banner < ActiveRecord::Base
  self.inheritance_column = false
  scope :valid, -> { where("start_date<='#{Date.today}' and '#{Date.today}'<end_date") }
  mount_uploader :image, BannerUploader

  validates_presence_of :start_date
  validates_presence_of :end_date

  def as_json
    {
        image: image.thumb.url,
        url: url
    }
  end
end
