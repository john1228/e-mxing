ActiveAdmin.register Activity do
  menu label: '活动', parent: '运营'
  filter :title, label: '标题'
  permit_params :id, :title, :cover, :pos, :content
  index title: '最新活动' do
    selectable_column
    column '标题', :title do |activity|
      truncate(activity.title)
    end
    column '封面', :title do |activity|
      image_tag(activity.cover.url, width: 75)
    end
    column '链接地址' do |activity|
      link_to('详情', activity_detail_path(activity))
    end
    actions
  end

  show title: ' 详情 ' do
    attributes_table do
      row(' 标题 ') { activity.title }
      row(' 封面 ') { image_tag(activity.cover.url, width: 150) }
    end
  end
  form partial: 'form'
end
