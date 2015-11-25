class News < ActiveRecord::Base
  mount_uploader :cover, NewsCoverUploader

  class<<self
    def top_news(category)
      [{
           name: '场馆推荐',
           tip: (category_news(category, '场馆推荐').first.title rescue '')
       },
       {
           name: '私教专访',
           tip: (category_news(category, '私教专访').first.title rescue '')
       },
       {
           name: "玩转#{category}",
           tip: (category_news(category, "玩转#{category}").first.title rescue '')
       },
       {
           name: '玩家攻略',
           tip: "大家聊#{category}"
       }]
    end

    def category_news(category, sub_category)
      where('? = ANY(tag_1)', "#{category}-#{sub_category}").order(id: :desc)
    end
  end

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
