ActiveAdmin.register Coach do
  menu label: '教练', priority: 4
  filter :profile_name, label: '昵称', as: :string
  actions :index, :show, :destroy
  index do
    column '美型号' do |coach|
      link_to("#{coach.profile_mxid}", admin_coach_path(coach))
    end
    column '昵称' do |coach|
      link_to(truncate("#{coach.profile_name}"), admin_coach_path(coach))
    end
    column '头像' do |coach|
      link_to(image_tag(coach.profile_avatar.thumb.url, height: 70), admin_coach_path(coach))
    end
    column '签名' do |coach|
      truncate(coach.profile_signature)
    end
    actions
  end

  show title: proc { |coach| "#{coach.profile_name}详情" } do
    panel '用戶信息' do
      table style: 'width: 100%' do
        tr do
          td link_to('课程', admin_coach_courses_path(coach), class: :button)
          td link_to('照片墙', admin_coach_coach_photos_path(coach), class: :button)
          td link_to('动  态', admin_coach_coach_dynamics_path(coach), class: :button)
        end
      end
    end
  end

  sidebar '用户资料', only: :show do
    attributes_table_for coach.profile do
      row('昵称') { |profile| profile.name }
      row('头像') { |profile| image_tag(profile.avatar.thumb.url) }
      row('签名') { |profile| profile.signature }
      row('性别') { |profile| profile.gender }
      row('生日') { |profile| (profile.birthday||Date.today.prev_year(15)).strftime('%Y-%m-%d') }
    end
  end
end
