ActiveAdmin.register ServicePhoto do
  menu label: '照片牆'

  belongs_to :service
  navigation_menu :service

  permit_params :photo

  index title: '照片墙', as: :grid, columns: 5 do |photo|
    div for: photo do
      resource_selection_cell photo
      div link_to(image_tag(photo.photo.thumb.url), photo.photo.url, popup: true)
    end
  end

  show do
    div image_tag(service_photo.photo.thumb.url)
  end


  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs '上传照片' do
      f.input :photo, label: '照片', as: :file, hint: f.object.photo.present? ? image_tag(f.object.photo.url(:thumb)) : content_tag(:span, '未上传照片')
    end
    f.actions
  end
end
