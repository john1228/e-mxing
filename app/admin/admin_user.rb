ActiveAdmin.register AdminUser do
  menu label: '管理员'
  config.per_page = 10
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column '邮箱', :email
    column '最后一次登录时间' do |admin_user|
      admin_user.current_sign_in_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column '登录次数',:sign_in_count
    column '创建时间' do |admin_user|
      admin_user.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "管理员" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
