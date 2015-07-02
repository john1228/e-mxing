ActiveAdmin.register ServiceMember do
  menu label: '私教'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  permit_params :service_id,
                coach_attributes: [:id, :mobile, :password, :signature, :name, :avatar, :gender, :identity, :birthday,
                                   :address, :target, :skill, :often, :hobby]
  before_filter :adjust, only: :create
  before_filter :update_coach, only: :update
  controller do
    def adjust
      params[:service_member][:coach_attributes][:hobby].reject! { |item| item.blank? }
      params[:service_member][:coach_attributes][:hobby] = params[:service_member][:coach_attributes][:hobby].join(',')
    end

    def update_coach
      params[:service_member][:coach_attributes][:hobby].reject! { |item| item.blank? }
      avatar = params[:service_member][:coach_attributes][:avatar]
      member = ServiceMember.find_by(id: params[:id])
      coach = member.coach
      update_params = {
          name: params[:service_member][:coach_attributes][:name],
          birthday: params[:service_member][:coach_attributes][:birthday],
          address: params[:service_member][:coach_attributes][:address],
          target: params[:service_member][:coach_attributes][:target],
          skill: params[:service_member][:coach_attributes][:target],
          often: params[:service_member][:coach_attributes][:target],
          hobby: params[:service_member][:coach_attributes][:hobby].join(',')
      }
      update_params = update_params.merge(avatar: avatar) unless avatar.blank?
      coach.update(update_params)
    end
  end

  index title: '旗下私教' do
    selectable_column
    column '昵称' do |member|
      "#{member.coach.profile_name}"
    end
    column '头像' do |member|
      image_tag("#{member.coach.profile_avatar.thumb.url}", height: 70)
    end
    column '签名' do |member|
      truncate(member.coach.profile.signature)
    end
    actions
  end
  show title: '私教' do
    div do
      'hello'
    end
  end

  sidebar '私教信息', only: :show do
    attributes_table_for service_member do
      row('登录名') { service_member.coach.mobile }
      row('昵称') { service_member.coach.profile.name }
      row('头像') { image_tag(service_member.coach.profile.avatar.thumb.url, height: 70) }
      row('生日') { service_member.coach.profile.age }
      row('性别') { service_member.coach.profile.gender.eql?(1) ? '女' : '男' }
      row('地址') { service_member.coach.profile_address }
      row('健身目标') { service_member.coach.profile.target }
      row('擅长领域') { service_member.coach.profile.skill }
      row('常去场馆') { service_member.coach.profile.often }
      row('健身兴趣') { service_member.coach.profile.interests_string }
    end
  end


  form partial: 'form'
end
