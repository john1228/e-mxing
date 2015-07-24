ActiveAdmin.register Course do
  menu label: '课程', parent: '课程'

  filter :name, label: '课程名'
  scope('0-全部', :all, default: true)
  scope('1-在线', :unprocessed) { |scope| scope.where(status: Course::STATUS[:online]) }
  scope('2-下线', :processed) { |scope| scope.where(status: Course::STATUS[:delete]) }
  index title: '在线课程' do
    selectable_column
    column '名称', :name
    column '类型', :type
    column '教学方式', :style
    column '单课时长', :during
    column '价格', :price
    column '建议课时', :proposal
    column '是否担保', :guarantee
  end

  form partial: 'form'
end
