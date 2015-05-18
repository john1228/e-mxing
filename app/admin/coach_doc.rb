ActiveAdmin.register CoachDoc do
  menu label: '身份资料'
  config.filters = false
  belongs_to :coach
  navigation_menu :coach
  permit_params :image
  index title: '身份资料', as: :grid, columns: 5 do |doc|
    div for: doc do
      resource_selection_cell(doc)
      div link_to(image_tag(doc.image.thumb.url, height: 70), doc.image.url, popup: true)
    end
  end


  form partial: 'form'
end
