ActiveAdmin.register Coach do
  menu label: '私教', priority: 4
  filter :profile_name, label: '昵称', as: :string
  filter :profile_address, label: '城市', as: :string

  csv do
    column('美型号') { |coach| coach.profile.mxid }
    column('名字') { |coach| coach.profile.name }
    column('性别') { |coach| (coach.profile.identity.eql?(1) ? '女' : '男') rescue '男' }
    column('注册手机号') { |coach| coach.mobile }
    column('照片墙数量') { |coach| coach.photos.count }
    column('课程数量') { |coach| Sku.where(seller_id: coach.id).where('sku like ?', 'CC%').count }
    column('注册时间') { |coach| coach.created_at.localtime.strftime('%Y-%m-%d') }
    column('所属机构') { |coach| coach.service.profile.name }
    column('所属机构号') { |coach| coach.service.profile.mxid }
    column('所属机构地址') { |coach| coach.service.profile.address }
  end

  actions :index, :show, :recommend, :recommend_result
  scope('0-全部', :all, default: true)
  scope('1-已推荐', :recommended)
  index do
    column '机构号' do |coach|
      coach.service.profile.mxid rescue ''
    end
    column '机构名' do |coach|
      coach.service.profile.name rescue '无'
    end
    column '美型号' do |coach|
      link_to("#{coach.profile.mxid}", admin_coach_path(coach))
    end
    column '昵称' do |coach|
      link_to(truncate("#{coach.profile.name}"), admin_coach_path(coach))
    end
    actions do |coach|
      if coach.recommend.nil?
        link_to('推荐', recommend_coach_path(coach), class: 'fancybox', data: {'fancybox-type' => 'ajax'})
      else
        link_to('取消推荐', cancel_recommend_coach_path(coach), method: :delete)
      end
    end
  end

  controller do
    def recommend
      @coach = Coach.find_by(id: params[:id])
      render layout: false
    end

    def recommend_result
      Recommend.create(type: Recommend::TYPE[:person], recommended_id: params[:id], recommended_tip: params[:tip])
      render layout: false
    end

    def cancel_recommend
      coach = Coach.find_by(id: params[:id])
      Recommend.remove(coach)
      redirect_to collection_path, alert: '取消推荐成功'
    end

    def coach
      @coach = Coach.find_by(id: params[:id])
      render layout: false
    end
  end

  show title: proc { |coach| "#{coach.profile.name}详情" } do
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
