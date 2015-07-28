ActiveAdmin.register ServiceCourse do
  menu label: '商品管理'
  filter :name, label: '名称'

  permit_params :name, :type, :style, :during, :proposal, :exp, :info, :special, :market_price, :selling_price, :store,
                service: [], agency: [], image: []

  scope('0-全部', :all, default: true)
  scope('1-在售', :online) { |scope| scope.where(status: ServiceCourse::STATUS[:online]) }
  scope('2-仓库', :offline) { |scope| scope.where(status: ServiceCourse::STATUS[:offline]) }
  index do
    selectable_column
    column(:name)
    column(:type)
    column(:name)
    column(:during)
    column(:proposal)
    column(:exp)
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  form partial: 'form'
end
