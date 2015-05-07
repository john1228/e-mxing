ActiveAdmin.register ServiceMember do
  menu label: '私教'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  permit_params :service_id, coach_attributes: [:id, :mobile, :password, :identity,
                                                :name, :avatar, :gender, :identity, :birthday,
                                                :address, :target, :skill, :often, :hobby]

  before_filter :adjust, only: [:create, :update]
  controller do
    def adjust
      params[:service_member][:coach_attributes][:hobby].reject! { |item| item.blank? }
      params[:service_member][:coach_attributes][:hobby] = params[:service_member][:coach_attributes][:hobby].join(',')
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
      truncate(member.coach.profile_interests)
    end
    actions
  end

  show title: "私教" do
    coach = service_member.coach
    panel '私教信息' do
      attributes_table_for coach do
        row('登录名') { coach.username }
        row('昵称') { coach.profile_name }
        row('头像') { image_tag(coach.profile_avatar.thumb.url, height: 70) }
        row('生日') { coach.profile_birthday.strftime('%Y-%m-%d') }
        row('性别') { coach.profile_gender.eql?(1) ? '女' : '男' }
        row('地址') { coach.profile_address }
        row('健身目标') { coach.profile_target }
        row('擅长领域') { coach.profile_skill }
        row('常去场馆') { coach.profile_often }
        row('健身兴趣') { coach.profile_interests_string }
      end
    end
  end

  form partial: 'form'
end
