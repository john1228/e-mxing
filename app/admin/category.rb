ActiveAdmin.register Category do
  menu label: '分类管理', parent: '运营'

  permit_params :name, :background, item: []

  index do
    selectable_column
    column :name
    column :item
    column :background
    actions
  end

  show do
    attributes_table :category do
      row :name
      row :item
      row :background
    end
  end
  form partial: 'form'
end
