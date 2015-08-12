ActiveAdmin.register Enthusiast do
  menu label: '用户', priority: 4
  filter :profile_name, label: '昵称', as: :string
  filter :mobile, label: '注册手机号'
  filter :created_at, label: '注册时间'
  actions :index, :show, :destroy
  permit_params :identity

  csv do
    column('美型号') { |enthusiast| enthusiast.profile.mxid }
    column('昵称') { |enthusiast| enthusiast.profile.name }
    column('注册电话') { |enthusiast| enthusiast.mobile }
    column('注册第三方') { |enthusiast| enthusiast.sns }
    column('注册时间') { |enthusiast| enthusiast.created_at.localtime }
  end

  index do
    selectable_column
    column '美型号' do |enthusiast|
      link_to("#{enthusiast.profile.mxid}", admin_enthusiast_path(enthusiast))
    end
    column '昵称' do |enthusiast|
      link_to(truncate("#{enthusiast.profile.name}"), admin_enthusiast_path(enthusiast))
    end
    column '头像' do |enthusiast|
      link_to(image_tag(enthusiast.profile.avatar.thumb.url, height: 70), admin_enthusiast_path(enthusiast))
    end
    column ' 注册时间' do |enthusiast|
      truncate(enthusiast.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'))
    end
    actions do |enthusiast|
      link_to '成为私教', pre_transfer_path(enthusiast), class: 'fancybox', data: {'fancybox-type' => 'ajax'}
    end
  end

  batch_action '拉黑' do |ids|
    User.find(ids).each { |user|
      user.dynamics.destroy_all
      user.dynamic_comments.destroy_all
      Rails.cache.delete(user.token)
      Blacklist.create(user_id: user.id)
    }
    redirect_to collection_path, alert: '拉黑成功'
  end

  controller do
    def transfer
      @enthusiast = Enthusiast.find_by(id: params[:id])
      render layout: false
    end

    def transfer_result
      begin
        enthusiast = Enthusiast.find_by(id: params[:id])
        enthusiast.tracks.destroy_all
        enthusiast.profile.update(identity: 1)
        ServiceMember.create(service_id: params[:service_id], coach_id: enthusiast.id)
      rescue
        @errors = '转换失败'
      end
      render layout: false
    end
  end

  show title: proc { |enthusiast| "#{enthusiast.profile.name}详情" } do
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
      row('生日') { |profile| profile.birthday.strftime('%Y-%m-%d') rescue Date.today.prev_year(15) }
    end
  end
end
