ActiveAdmin.register Activity do
  menu label: '活动', parent: '配置'
  filter :title, label: '标题'
  permit_params :id, :title, :cover, :pos, :content
  index title: '新闻列表' do
    selectable_column
    column '标题', :title do |activity|
      truncate(activity.title)
    end
    column '封面', :title do |activity|
      image_tag(activity.cover.url, width: 75)
    end
    column '链接地址' do |activity|
      link_to('详情', '#', onclick: "javascript:void window.open('http://www.textfixer.com','1437100812098','toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');return false;")
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
