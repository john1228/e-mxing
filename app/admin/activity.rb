ActiveAdmin.register Activity do
  menu label: '活动', parent: '配置'
  filter :title, label: '标题'
  permit_params :id, :activity_type, :group_id, :title, :cover, :address, :start_date, :end_date, :content

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
    column '链接地址' do |activity|
      link_to('详情', activity_detail_path(activity), popup: true)
    end
    actions
  end

  show title: '新闻详情' do
    panel '' do
      attributes_table_for activity do
        row('标题') { activity.title }
        row('封面') { image_tag(activity.cover.thumb.url, width: 150) }
      end
    end
  end


  form partial: 'form'

  #
  # form html: {enctype: 'multipart/form-data'} do |f|
  #   f.inputs '发布活动' do
  #     f.input :activity_type, label: '活动类型', as: :select, collection: [['报名活动', 0], ['抽奖活动', 1]], prompt: '请选择类型'
  #     f.input :group_id, label: '主办群', as: :select, collection: Group.pluck(:name, :id), prompt: '请选择主办方'
  #     f.input :title, label: '标题'
  #     f.input :cover, label: '封面', as: :file, hint: f.object.cover.present? ? image_tag(f.object.cover.url(:thumb)) : content_tag(:span, '未上传照片')
  #     f.input :address, label: '地址'
  #     f.input :start_date, label: '开始', as: :datepicker
  #     f.input :end_date, label: '结束', as: :datepicker
  #     f.input :content, label: '活动内容', as: :ckeditor, hint: content_tag(:span, '内容插入图片时,请将图片到宽度设置到100%', style: 'color:red')
  #   end
  #   f.actions
  # end


end
