ActiveAdmin.register AdminUser do
  menu label: '管理员', parent: '运营'
  config.per_page = 10
  permit_params :email, :password, :password_confirmation,
                :role, :service_id, :name, :avatar, :birthday,
                :gender, :mobile, :remark

  index do
    selectable_column
    id_column
    column '邮箱', :email
    column '最后一次登录时间' do |admin_user|
      admin_user.current_sign_in_at.strftime('%Y-%m-%d %H:%M:%S') rescue ''
    end
    column '登录次数', :sign_in_count
    column '创建时间' do |admin_user|
      admin_user.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end
  show do
    attributes_table do
      row('用户名') { |admin_user| admin_user.email }
      row('角色') { |admin_user|
        admin_user.role
      }
      row('服务号') { |admin_user|
        Service.find_by(id: admin_user.service_id).profile.name if admin_user.store_manager?
      }
    end
  end
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form partial: 'form'
end
