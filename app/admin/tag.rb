ActiveAdmin.register Tag do
  menu label: '标签管理', parent: '运营'


  index do
    selectable_column
    column :tag
    column :name
    column :background
  end

  show do
    attributes_fo :tag do
      row('类型') { |tag| tag.type }
      row('名字') { |tag| tag.name }
      row('背景图') { |tag| tag.background }
    end
  end
  form partial: 'form'
end
