ActiveAdmin.register Tag do
  menu label: '标签管理', parent: '运营'

  index do
    selectable_column
    column :type
    column :name
    column :background
  end
end
