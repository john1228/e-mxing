ActiveAdmin.register Enthusiast do
  menu label: '用户', priority: 4
  filter :profile_name, label: '昵称', as: :string
  actions :index, :show, :destroy
  index do
    column '美型号' do |enthusiast|
      link_to("#{enthusiast.profile_mxid}", admin_enthusiast_path(enthusiast))
    end
    column '昵称' do |enthusiast|
      link_to("#{enthusiast.profile_name}", admin_enthusiast_path(enthusiast))
    end
    column '头像' do |enthusiast|
      link_to(image_tag(enthusiast.profile_avatar.thumb.url, height: 70), admin_enthusiast_path(enthusiast))
    end
    column '签名' do |enthusiast|
      truncate(enthusiast.profile_signature)
    end
    actions
  end

  show title: proc { |enthusiast| "#{enthusiast.profile_name}详情" } do
    panel '用戶信息' do
      table style: 'width: 100%' do
        tr do
          td link_to('照片墙', admin_enthusiast_photos_path(enthusiast), class: :button)
          td link_to('动  态', admin_enthusiast_dynamics_path(enthusiast), class: :button)
          td link_to('运动轨迹', admin_enthusiast_tracks_path(enthusiast), class: :button)
        end
      end
    end
  end

  sidebar '用户资料', only: :show do
    attributes_table_for enthusiast.profile do
      row('昵称') { |profile| profile.name }
      row('头像') { |profile| image_tag(profile.avatar.thumb.url) }
      row('签名') { |profile| profile.signature }
      row('性别') { |profile| profile.gender }
      row('生日') { |profile| profile.birthday.strftime('%Y-%m-%d') }
    end
  end

  # form html: {enctype: 'multipart/form-data'} do |f|
  #   f.inputs '添加服务号' do
  #     f.input :identity, as: :hidden, input_html: {value: 2}
  #     f.input :username, label: '用户名'
  #     f.input :password, label: '密码'
  #     f.input :name, label: '昵称'
  #     f.input :avatar, label: '头像', as: :file
  #   end
  #   f.actions
  # end

end
