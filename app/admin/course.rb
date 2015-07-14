ActiveAdmin.register Course do
  menu label: '课程'
  belongs_to :coach
  navigation_menu :coach

  filter :name, label: '课程名'
  index do
    selectable_column
    column '名称', :name
    column '类型', :type
    column '教学方式', :style
    column '单课时长', :during
    column '价格', :price
    column '建议课时', :proposal
    column '是否担保', :guarantee
  end
end
