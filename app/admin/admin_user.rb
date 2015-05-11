ActiveAdmin.register AdminUser do
  menu label: '管理员'
  config.per_page = 10
  permit_params :email, :password, :password_confirmation, :role, :service_id

  index do
    selectable_column
    id_column
    column '邮箱', :email
    column '最后一次登录时间' do |admin_user|
      admin_user.current_sign_in_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column '登录次数', :sign_in_count
    column '创建时间' do |admin_user|
      admin_user.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end
  show do
    attributes_table do
      row('用户名') { admin_user.email }
      row('角色') { admin_user.email }
      row('服务号') { admin_user.email }
    end
  end
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "管理员" do
      f.input :email, label: '用户名'
      f.input :password, label: '设置密码'
      f.input :password_confirmation, label: '确认密码'
      f.input :role, label: '角色', as: :select, collection: [['超级管理员', 0], ['服务号管理员', 1], ['内容管理员', 2]], prompt: '请选择角色'
      f.input :service_id, label: '服务号', as: :select, collection: Service.includes(:profile).pluck('profiles.name', :id), prompt: '请选择服务号'
    end
    f.actions
  end

end
