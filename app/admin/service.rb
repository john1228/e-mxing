ActiveAdmin.register Service do
  menu label: '服务号', priority: 2

  permit_params :identity, :name, :username, :password, :avatar

  filter :profile_name, label: '昵称', as: :string
  index do
    column '美型号' do |user|
      link_to("#{user.profile_mxid}", admin_user_path(user))
    end
    column '昵称' do |user|
      link_to("#{user.profile_name}", admin_user_path(user))
    end
    column '头像' do |user|
      link_to(image_tag(user.profile_avatar.thumb.url, height: 70), admin_user_path(user))
    end
    column '签名' do |user|
      truncate(user.profile_signature)
    end
    actions
  end


  show do
    panel '服务号' do
      table style: 'width: 100%' do
        tr do
          td link_to('照片墙', admin_service_service_photos_path(service), class: :button)
          td link_to('动  态', admin_service_service_dynamics_path(service), class: :button)
          td link_to('团操', admin_service_service_tracks_path(service), class: :button)
          td link_to('旗下私教', admin_service_service_members_path(service), class: :button)
        end
      end
    end
  end

  sidebar '基本資料', only: :show do
    attributes_table_for service do
      row('昵称') { service.profile_name }
      row('头像') { image_tag(service.profile_avatar.thumb.url) }
    end
  end
end
