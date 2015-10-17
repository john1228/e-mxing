class Banner < ActiveRecord::Base
  self.inheritance_column = false
  scope :valid, -> { where("start_date<='#{Date.today}' and '#{Date.today}'<end_date") }
  mount_uploader :image, BannerUploader
  scope :boot, -> { where(type: [11, 12, 13, 14, 15, 16]).where('start_date<=? AND end_date>=?', Date.today, Date.today) }
  scope :app, -> { where(type: [21, 22, 23, 24, 25, 26]).where('start_date<=? AND end_date>=?', Date.today, Date.today) }

  validates_presence_of :start_date
  validates_presence_of :end_date

  def as_json
    {
        type: type,
        image: image.thumb.url,
        url: url,
        link_id: link_id,
        start_date: start_date.strftime('%Y-%m-%d'),
        end_date: end_date.strftime('%Y-%m-%d'),
    }
  end
end
