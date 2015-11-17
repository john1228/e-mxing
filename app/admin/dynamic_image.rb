ActiveAdmin.register DynamicImage do
  menu label: '动态图片'
  actions :index
  filter :tag, label: '标记'
  index do
    selectable_column
    column('发布者') do |image|
      image.dynamic.user.profile.mxid
    end
    column('发布者名称') do |image|
      image.dynamic.user.profile.name
    end
    column('发布者头像') do |image|
      image_tag(image.dynamic.user.profile.avatar.url, height: 50)
    end
    column('图片') do |image|
      image_tag(image.image.url, width: 50)
    end
    column('发布内容') do |image|
      image.dynamic.content
    end
    column('发布时间') { |image| image.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S') }
  end
  
  Tag.dynamics.pluck(:name).each do |item|
    batch_action item do |ids|
      DynamicImage.where(id: ids).update_all("tag = array_append(tag,'#{params[:batch_action]}')")
      redirect_to collection_path, alert: '标记成功'
    end
  end
end
