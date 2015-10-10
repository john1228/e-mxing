class News < ActiveRecord::Base
  TAG = %w'健身知识 你问我答 热门场馆 金牌私教'
  mount_uploader :cover, NewsCoverUploader


  def as_json
    {
        title: title,
        cover: cover.thumb.url,
        width: cover_width,
        height: cover_height,
        content: Nokogiri::HTML(content).inner_text[0, 200],
        url: $host + "/news/#{id}",
        created_at: created_at.to_i
    }
  end
end
