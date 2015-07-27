ActiveAdmin.register ServiceCourse do
  menu label: '商品管理'
  filter :name, label: '名称'

  #scope
  scope('0-全部', :all, default: true)
  scope('1-在售', :online) { |scope| scope.where(status: ServiceCourse::STATUS[:online]) }
  scope('2-仓库', :offline) { |scope| scope.where(status: ServiceCourse::STATUS[:offline]) }
  index do
    selectable_column
    column('编码', :sku)
  end


  form partial: 'form'
end
