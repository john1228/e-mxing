ActiveAdmin.register News do
  menu label: '新闻', parent: '运营'
  filter :title, label: '标题'
  permit_params :id, :tag, :title, :cover, :content

  index  do
    selectable_column
    column '标题', :title do |news|
      truncate(news.title)
    end
    column '分类', :title do |news|
      news.tag
    end
    column '封面', :title do |news|
      image_tag(news.cover.url, width: 69)
    end
    column '链接地址' do |news|
      link_to('详情', news_detail_path(news))
    end
    actions
  end

  show title: '新闻详情' do
    panel '' do
      attributes_table_for news do
        row('标题') { news.title }
        row('分类') { news.tag }
        row('封面') { image_tag(news.cover.url, width: 69*2) }
        row('链接') { link_to('详情', news_detail_path(news)) }
      end
    end
  end
  form partial: 'form'
end
