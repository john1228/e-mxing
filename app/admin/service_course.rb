ActiveAdmin.register ServiceCourse do
  menu label: '机构课程', parent: '商品管理'

  filter :name, label: '名称'

  permit_params :name, :type, :style, :during, :limit_start, :limit_end, :proposal, :exp, :intro, :special, :market_price, :selling_price, :store,
                :agency, :limit, service: [], image: []
  actions :index, :new, :create, :show
  scope('0-全部', :all, default: true)
  scope('1-在售', :online) { |scope| scope.where(status: ServiceCourse::STATUS[:online]) }
  scope('2-仓库', :offline) { |scope| scope.where(status: ServiceCourse::STATUS[:offline]) }
  index do
    selectable_column
    column(:name)
    column { |course| course.type_name }
    column { |course| "#{course.during}分钟" }
    column(:proposal)
    column { |course| "#{course.exp}天" }
    column('关联机构') { |course|
      skus = Sku.where('sku LIKE ?', 'SC'+'-' + '%06d' % course.id + '%')
      sellers = skus.map { |sku| [sku.seller_user.profile.mxid, sku.seller_user.profile.name] }
      sellers.join('|')
    }
    actions do |course|
      if course.status.eql?(1)
        link_to '下架', offline_path(course), method: :post
      else
        link_to '上架', online_path(course), method: :post
      end
    end
  end

  controller do
    def online
      ServiceCourse.find_by(id: params[:id]).update(status: ServiceCourse::STATUS[:online])
      redirect_to collection_path, alert: '上架成功'
    end

    def offline
      ServiceCourse.find_by(id: params[:id]).update(status: ServiceCourse::STATUS[:offline])
      redirect_to collection_path, alert: '下架成功'
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
