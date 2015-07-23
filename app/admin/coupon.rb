ActiveAdmin.register Coupon do
  menu label: '优惠券', parent: '运营'
  permit_params :name, :limit_category, :limit_ext, :min, :discount, :start_date, :end_date, :active, :info

  filter :name, label: '优惠券名称'
  index do
    selectable_column
    column('名称', :name)
    column('类型', :limit_category)
    column('对应', :limit_ext)
    column('最小金额', :min)
    column('折扣金额', :discount)
    column('开始日期') { |coupon| coupon.start_date.strftime('%Y-%m-%d') }
    column('截至日期') { |coupon| coupon.end_date.strftime('%Y-%m-%d') }
    column '激活状态', :active
    actions
  end

  controller do
    def list
      case params[:type].to_i
        when 1
          data = []
        when 2
          data = Service.all.includes(:profile).pluck('users.id', 'profiles.name')
        when 3
          data = Coach.order(id: :desc).all.pluck('users.id', 'profiles.name')
        when 4
          data = Course.order(id: :desc).all.pluck(:id, :name)
      end
      render json: data, layout: false
    end
  end

  show title: '优惠券详情' do

  end

  form partial: 'form'
end
