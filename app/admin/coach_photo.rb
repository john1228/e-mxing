ActiveAdmin.register CoachPhoto do
  menu label: '照片牆'
  config.filters = false
  belongs_to :coach
  navigation_menu :coach
  permit_params :photo

  index title: '照片墙', as: :grid, columns: 5 do |photo|
    div for: photo do
      resource_selection_cell photo
      div link_to(image_tag(photo.photo.thumb.url, height: 140), photo.photo.url, popup: ['original_image', 'height=700,width=900'])
    end
  end

  show do
    div image_tag(coach_photo.photo.thumb.url)
  end


  form partial: 'form'
end
