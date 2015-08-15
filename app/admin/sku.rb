ActiveAdmin.register Sku do
  menu label: '全部课程', parent: '商品管理'
  config.batch_actions = false
  actions :index, :show, :recommend, :cancel_recommend
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
    actions do |sku|
      if sku.recommend
        link_to('取消爆款', cancel_recommend_course_path(sku))
      else
        link_to('设为爆款', recommend_course_path(sku))
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