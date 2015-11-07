class News < ActiveRecord::Base
  enum tag: {knowledge: '健身知识', question: '你问我答', venues: '热门场馆', gyms: '金牌私教'}
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

  def top_news(category)
    [{
         name: '场馆推荐',
         tip: (News.category_news(category, tags[:venues]).first.title rescue '')
     },
     {
         name: '私教专访',
         tip: (News.category_news(category, tags[:gyms]).first.title rescue '')
     },
     {
         name: "玩转#{category}",
         tip: (News.category_news(category, tags[:knowledge]).first.title rescue '')
     },
     {
         name: '玩家攻略',
         tip: "大家聊#{category}"
     }]
  end


  def category_news(category, sub_category)
    where('? = ANY(tag_1) and tag = ?', category, sub_category).order(id: :desc)
  end
end
