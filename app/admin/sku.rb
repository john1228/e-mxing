ActiveAdmin.register Sku do
  menu label: '商品'
  actions :index, :show, :recommend, :cancel_recommend
  filter :course_type
  filter :course_name
  filter :seller
  filter :selling_price
  filter :store
  filter :status, as: :select, collection: [['库存中', 0], ['已上架', 1]]
  filter :address

  scope('0-储值卡', :stored) { |scope| scope.stored }
  scope('1-次卡', :measured) { |scope| scope.measured }
  scope('2-时效卡', :clocked) { |scope| scope.clocked }
  scope('3-课程', :course) { |scope| scope.course }

  index do
    selectable_column
    column(:course_name)
    column('课程封面') { |sku| image_tag(sku.course_cover, width: 75, height: 75) }
    column(:market_price)
    column(:selling_price)
    column('库存') { |sku|
      if sku.store.eql?(-1)
        '无限库存'
      elsif sku.eql?(0)
        '已售罄'
      else
        sku.store
      end
    }
    column('限购') { |sku|
      if sku.limit.eql?(-1)
        '不限购'
      else
        sku.limit
      end
    }
    column(:seller)
    column(:address)
    column('状态') { |sku|
      sku.status.eql?(1) ? status_tag('已上架', :ok) : status_tag('库存中', :error)
    }
  end

  batch_action :offline do |ids|
    Sku.where(sku: ids).each { |sku|
      sku.course.update(status: ServiceCourse::STATUS[:offline])
    }
    redirect_to collection_path, alert: '下架成功'
  end

  show title: '课程详情' do
    attributes_table do
      row(:sku)
      row(:course_name)
      row('封面') { image_tag(sku.course_cover, width: 100) }
      row(:market_price)
      row(:selling_price)
      row(:seller)
      row('服务号') { sku.seller_user.is_a?(Coach) ? sku.seller_user.service.profile.name : sku.seller_user.profile.name }
      row(:address)
    end
  end
end