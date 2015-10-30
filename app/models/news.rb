class News < ActiveRecord::Base
  enum tag: {knowledge: '健身知识', question: '你问我答',venues: '热门场馆',gyms: '金牌私教'}
  mount_uploader :cover, NewsCoverUploader


  def as_json
    {
        title: title,
        cover: cover.url,
        width: cover_width,
        height: cover_height,
        content: Nokogiri::HTML(content).inner_text[0, 200],
        url: $host + "/news/#{id}",
        created_at: created_at.to_i
    }
  end
end
