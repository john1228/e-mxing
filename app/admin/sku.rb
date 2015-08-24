ActiveAdmin.register Sku do
  menu label: '全部课程', parent: '商品管理'
  config.batch_actions = false
  actions :index, :show, :recommend, :cancel_recommend
  filter :course_type
  filter :course_name
  filter :seller
  filter :selling_price
  filter :store

  scope('0-私教课程', :coach_courses)
  scope('1-机构课程', :service_courses)
  scope('2-已推荐', :recommended, default: true)

  index do
    column(:course_name)
    column('课程封面') { |sku| image_tag(sku.course_cover, width: 50, height: 50) }
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
    actions do |sku|
      if sku.status.eql?(1)
        if sku.recommend
          link_to('取消爆款', cancel_recommend_course_path(sku), method: :delete)
        else
          link_to('设为爆款', recommend_course_path(sku), method: :post)
        end
      end
    end
  end

  controller do
    def recommend
      Recommend.create(type: Recommend::TYPE[:course], recommended_id: params[:id])
      redirect_to collection_path, alert: '添加爆款成功'
    end

    def cancel_recommend
      Recommend.destroy_all(type: Recommend::TYPE[:course], recommended_id: params[:id])
      redirect_to collection_path, alert: '取消爆款成功'
    end
  end

end