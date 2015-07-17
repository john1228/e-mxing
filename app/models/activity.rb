class Activity < ActiveRecord::Base
  mount_uploader :cover, ActivityCoverUploader
  TOP = {'第一位' => 1, '第二位' => 2, '第三位' => 3}
  class << self
    def top_1
      where(pos: TOP['第一位']).order(updated_at: :desc).take
    end

    def top_2
      where(pos: TOP['第二位']).order(updated_at: :desc).take
    end

    def top_3
      where(pos: TOP['第三位']).order(updated_at: :desc).take
    end
  end

  def as_json
    {
        title: title,
        cover: cover.url,
        url: $host + "/activities/#{id}",
    }
  end
end
