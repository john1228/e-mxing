ActiveAdmin.register Coupon do
  menu label: '优惠券', parent: '运营'

  index do
    selectable_column
    column '优惠码', :no
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

  form partial: 'form'
end
