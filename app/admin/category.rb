ActiveAdmin.register Category do
  menu label: '分类管理', parent: '运营'

  permit_params :name, :background, item: []

  index do
    selectable_column
    column :name
    column :item
    column :background
  end

  show do
    attributes_table_for :category do
      row('分类名') { category.name }
      row('包含') { category.item }
      row('背景图') { category.background }
    end
  end
  form partial: 'form'


end
