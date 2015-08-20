ActiveAdmin.register Coupon do
  menu label: '优惠券', parent: '运营'
  permit_params :name, :limit_category, :limit_ext, :min, :discount, :start_date, :end_date, :info, :amount
  filter :name, label: '优惠券名称'
  index do
    selectable_column
    column('名称', :name)
    column('类型') { |coupon|
      case coupon.limit_category
        when '1'
          '通用'
        when '2'
          '机构'
        when '3'
          '私教'
        when '4'
          '课程'
      end
    }
    column('最小金额', :min)
    column('折扣金额', :discount)
    column('开始日期') { |coupon| coupon.start_date.strftime('%Y-%m-%d') }
    column('截至日期') { |coupon| coupon.end_date.strftime('%Y-%m-%d') }
    column '激活状态', :active
    actions do |coupon|
      if coupon.active
        link_to('下架', offline_coupon_path(coupon), method: :post)
      else
        link_to('上架', online_coupon_path(coupon), method: :post)
      end
    end
  end

  controller do
    def online
      Coupon.find_by(id: params[:id]).update(active: Coupon::STATUS[:online])
      redirect_to collection_path, alert: '上架成功'
    end

    def offline
      Coupon.find_by(id: params[:id]).update(active: Coupon::STATUS[:offline])
      redirect_to collection_path, alert: '下架成功'
    end
  end

  show do

  end
  form partial: 'form'
end
