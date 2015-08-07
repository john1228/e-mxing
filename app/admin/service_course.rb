ActiveAdmin.register ServiceCourse do
  menu label: '商品管理'
  filter :name, label: '名称'

  permit_params :name, :type, :style, :during, :limit_start, :limit_end, :proposal, :exp, :intro, :special, :market_price, :selling_price, :store,
                :agency, :limit, service: [], image: []
  actions :index, :show
  scope('0-全部', :all, default: true)
  scope('1-在售', :online) { |scope| scope.where(status: ServiceCourse::STATUS[:online]) }
  scope('2-仓库', :offline) { |scope| scope.where(status: ServiceCourse::STATUS[:offline]) }
  index do
    selectable_column
    column(:name)
    column(:type)
    column(:during)
    column(:proposal)
    column(:exp)
    actions do |course|
      link_to '上架', online_path(course), method: :post unless course.status.eql?(0)
      link_to '下架', '', method: :post unless course.status.eql?(1)
    end
  end

  controller do
    def online
      ServiceCourse.find_by(id: params[:id]).update(status: ServiceCourse::STATUS[:online])
      redirect_to collection_path, alert: '上架成功'
    end
  end

  show do
    attributes_table do
      row :name
      row :type
      row :during
      row :proposal
      row :exp
    end
  end

  form partial: 'form'
end
