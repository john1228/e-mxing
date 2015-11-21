ActiveAdmin.register Tag do
  menu label: '标签管理', parent: '运营'

  permit_params :tag, :name, :background

  index do
    selectable_column
    column '分类' do |tag|
      I18n.t(tag.tag, scope: [:enums, :tag, :tag])
    end
    column :name
  end

  show do
    attributes_table_for :tag do
      row('类型') { |tag| tag.to_json }
      row('名字') { |tag| tag.to_json }
    end
  end
  form partial: 'form'
end
