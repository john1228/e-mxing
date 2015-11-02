ActiveAdmin.register CoachPhoto do
  menu label: '照片牆'
  config.filters = false
  belongs_to :coach
  navigation_menu :coach
  permit_params :photo

  index as: :grid do |photo|
    div for: photo do
      resource_selection_cell photo
      div link_to(image_tag(photo.photo.url, height: 140), photo.photo.url, popup: ['original_image', 'height=700,width=900'])
    end
  end

  show do
    div image_tag(coach_photo.photo.url)
  end


  form partial: 'form'
end
