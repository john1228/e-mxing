ActiveAdmin.register ServiceMember do
  menu label: '私教'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  permit_params :service_id,
                coach_attributes: [:id, :mobile, :password, profile_attributes: [:id, :name, :avatar, :birthday, :gender, :signature, :identity, hobby: []]]
  controller do
    def new
      @service = Service.find_by(id: params[:service_id])
      @service_member = @service.service_members.new
      @service_member.build_coach
      @service_member.coach.profile = Profile.coach.new
    end
  end

  index do
    selectable_column
    column '昵称' do |member|
      "#{member.coach.profile.name}"
    end
    column '头像' do |member|
      image_tag("#{member.coach.profile.avatar.url}", height: 70)
    end
    column '签名' do |member|
      truncate(member.coach.profile.signature)
    end
    actions
  end

  show title: '私教' do
    render 'show'
  end

  sidebar '私教信息', only: :show do
    attributes_table_for service_member do
      row('登录名') { service_member.coach.mobile }
      row('昵称') { service_member.coach.profile.name }
      row('头像') { image_tag(service_member.coach.profile.avatar.url, height: 70) }
      row('年龄') { service_member.coach.profile.age }
      row('性别') { service_member.coach.profile.gender.eql?(1) ? '女' : '男' }
      row('地址') { service_member.coach.profile.address }
      row('健身目标') { service_member.coach.profile.target }
      row('擅长领域') { service_member.coach.profile.skill }
      row('常去场馆') { service_member.coach.profile.often }
      row('健身兴趣') { service_member.coach.profile.interests_string }
    end
  end


  form partial: 'form'
end
