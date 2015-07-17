ActiveAdmin.register Gallery do
  menu label: '图库'
  permit_params :tag, images_attributes: [:id, :image]
  form partial: 'form'
end
