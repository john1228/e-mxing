ActiveAdmin.register News do
  menu label: '新闻',parent: '配置'
  filter :title, label: '标题'
  permit_params :id, :title, :cover, :content

  index title: '新闻列表' do
    selectable_column
    column '标题', :title do |news|
      truncate(news.title)
    end
    column '封面', :title do |news|
      image_tag(news.cover.thumb.url, width: 69)
    end
    column '链接地址' do |news|
      link_to('详情', "/html/news/#{news.url}", popup: true)
    end
    actions
  end

  show title: '新闻详情' do
    panel '' do
      attributes_table_for news do
        row('标题') { news.title }
        row('封面') { image_tag(news.cover.thumb.url, width: 69*2) }
        row('链接') { news.url }
      end
    end
  end


  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs '发布新闻' do
      f.input :title, label: '标题'
      f.input :cover, label: '照片', as: :file, hint: f.object.cover.present? ? image_tag(f.object.cover.url(:thumb), width: 69) : content_tag(:span, '未上传照片')
      f.input :content, label: '内容', as: :ckeditor
    end
    f.actions
  end
end
