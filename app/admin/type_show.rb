ActiveAdmin.register TypeShow do
  menu label: '型男美女', parent: '运营'
  filter :title, label: '标题'
  permit_params :id, :title, :cover, :content

  index title: '型男美女' do
    selectable_column
    column '标题', :title do |show|
      truncate(show.title)
    end
    column '封面', :title do |show|
      image_tag(show.cover.thumb.url, width: 69)
    end
    column '链接地址' do |show|
      link_to('详情', type_show_detail_path(show))
    end
    actions
  end

  show do
    attributes_table do
      row('标题') { type_show.title }
      row('封面') { image_tag(type_show.cover.thumb.url) }
      row('链接') { link_to('详情', news_detail_path(type_show)) }
    end
  end


  form partial: 'form'
  # form html: {enctype: 'multipart/form-data'} do |f|
  #   f.inputs '发布新闻' do
  #     f.input :title, label: '标题'
  #     f.input :cover, label: '封面', as: :file, hint: f.object.cover.present? ? image_tag(f.object.cover.url(:thumb), width: 69) : content_tag(:span, '未上传照片')
  #     f.input :content, label: '内容', as: :ckeditor, hint: content_tag(:span, '内容插入图片时,请把图片的宽高设置为空', style: 'color:red')
  #   end
  #   f.actions
  # end

end
