ActiveAdmin.register Activity do
  menu label: '活动',parent: '配置'
  filter :title, label: '标题'
  permit_params :id, :title, :cover, :address, :time, :url

  index title: '新闻列表' do
    selectable_column
    column '标题', :title do |activity|
      truncate(activity.title)
    end
    column '封面', :title do |activity|
      image_tag(activity.cover.thumb.url, width: 75)
    end
    column '地址', :address
    column '时间', :time
    column '链接地址' do |news|
      link_to('详情', news.url, popup: true)
    end
    actions
  end

  show title: '新闻详情' do
    panel '' do
      attributes_table_for activity do
        row('标题') { activity.title }
        row('封面') { image_tag(activity.cover.thumb.url, width: 150) }
        row('链接') { activity.url }
      end
    end
  end


  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs '发布活动' do
      f.input :title, label: '标题'
      f.input :cover, label: '封面', as: :file, hint: f.object.cover.present? ? image_tag(f.object.cover.url(:thumb)) : content_tag(:span, '未上传照片')
      f.input :address, label: '地址'
      f.input :time, label: '时间'
      f.input :url, label: '链接地址'
    end
    f.actions
  end


end
