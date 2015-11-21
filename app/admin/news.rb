ActiveAdmin.register News do
  menu label: '新闻', parent: '运营'
  filter :title, label: '标题'
  permit_params :id, :tag, :title, :cover, :content

  index do
    selectable_column
    column '标题', :title do |news|
      truncate(news.title)
    end
    column '分类', :title do |news|
      I18n.t(news.tag, scope: [:enums, :news, :tag])
    end
    column '封面', :title do |news|
      image_tag(news.cover.url, width: 69)
    end
    column '链接地址' do |news|
      link_to('详情', news_detail_path(news))
    end
    column '标签' do |news|
      (news.tag_1||[]).join('|')
    end
    actions do |news|
      link_to_modal "标签", mark_news_path(news), rel: 'model:open'
    end
  end

  controller do
    def mark
      @news = News.find(params[:id])
      render layout: false
    end

    def mark_result
      news = News.find(params[:id])
      news.update(tag_1: params[:tag])
      redirect_to collection_path, alert: '标记成功'
    end
  end

  show title: ' 新闻详情 ' do
    panel ' ' do
      attributes_table_for news do
        row(' 标题 ') { news.title }
        row(' 分类 ') { news.tag }
        row(' 封面 ') { image_tag(news.cover.url, width: 69*2) }
        row(' 链接 ') { link_to(' 详情 ', news_detail_path(news)) }
      end
    end
  end
  form partial: 'form'
end
