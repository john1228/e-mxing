ActiveAdmin.register Gallery do
  menu label: '图库'
  filter :tag, label: '标记', as: :select, collections: Gallery::TAGS
  permit_params :tag, images_attributes: [:id, :image, :caption]
  form partial: 'form'
  index title: '图库', as: :grid, columns: 5 do |gallery|
    div for: gallery do
      resource_selection_cell gallery
      div do
        render partial: 'gallery', locals: {images: gallery.images, gallery: gallery.id}
      end
    end
  end
end
