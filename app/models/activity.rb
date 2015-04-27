class Activity < ActiveRecord::Base
  mount_uploader :cover, ActivityCoverUploader
  belongs_to :group
  has_many :applies

  class << self
    def themes
      theme_ary = INTERESTS['items'].map { |item| [item['name'], item['id']] }
      theme_ary << ['其他', 0]
      theme_ary
    end
  end

  def theme_name
    name = ''
    for item in Activity::themes
      if item[1].eql?(theme)
        name = item[0]
        break
      end
    end
    name
  end


  def stage
    if start_date > Date.today
      1
    elsif start_date<=Date.today && Date.today<=end_date
      2
    else
      3
    end
  end

  def as_json
    {
        title: title,
        cover: $host + cover.thumb.url,
        address: address,
        time: "#{start_date}~#{end_date}",
        url: $host + "/activities/#{id}"
    }
  end
end
