ActiveAdmin.register User do
  menu label: '用户'

  filter :profile_name, label: '昵称', as: :string
  actions :index, :show, :edit
  scope '1-爱好者', :fan, default: :true
  scope '2-私教', :coach
  scope '3-商家', :service

  index do
    column '美型号' do |user|
      link_to("#{user.profile.mxid}", admin_user_path(user))
    end
    column '昵称' do |user|
      link_to("#{user.profile.name}", admin_user_path(user))
    end
    column '头像' do |user|
      link_to(image_tag(user.profile.avatar.thumb.url, height: 70), admin_user_path(user))
    end
    column '身份' do |user|
      if user.is_coach?
        status_tag('私教', :warn)
      elsif user.is_service?
        status_tag('服务号', :error)
      else
        status_tag('愛好者')
      end
    end
    actions
  end

  show do
    panel '用户资料' do
      table style: 'width: 100%' do
        tr do
          td link_to('照片墙', admin_user_photos_path(user))
          td link_to('动态', admin_user_tracks_path(user))
          td link_to('运动轨迹', admin_user_tracks_path(user))
          td link_to('私教', admin_user_tracks_path(user)) if user.is_service?
        end
      end
    end
  end

  sidebar '用户资料', only: :show do
    attributes_table_for user.profile do
      row('昵称') { |profile| profile.name }
      row('头像') { |profile| image_tag(profile.avatar.thumb.url) }
      row('签名') { |profile| profile.signature }
      row('性别') { |profile| profile.gender }
      row('生日') { |profile| profile.birthday.strftime('%Y-%m-%d') }
    end
  end
end
