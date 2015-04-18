ActiveAdmin.register ServiceMember do
  menu label: '私教'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  permit_params :service_id, coach_attributes: [:username, :password, :name, :avatar, :gender, :identity, :birthday, :address, :target, :skill, :stadium, :interests => []]

  before_filter :adjust, only: [:create, :update]
  controller do
    def adjust
      params[:service_member][:coach_attributes][:interests].reject! { |item| item.blank? }
      params[:service_member][:coach_attributes][:interests] = params[:service_member][:coach_attributes][:interests].join(',')
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
        row('健身兴趣') { coach.profile_interests }
      end
    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.semantic_errors
    f.inputs '信息' do
      f.semantic_fields_for :coach, f.object.coach||Coach.new do |coach|
        coach.input :identity, as: :hidden, input_html: {value: 1}
        coach.input :username, label: '登录名|手机号'
        coach.input :password, label: '密码', as: :password

        coach.input :name, label: '昵称', input_html: {value: f.object.coach.present? ? f.object.coach.profile_name : ''}
        coach.input :avatar, label: '头像', as: :file
        coach.input :birthday, label: '生日', as: :datepicker, input_html: {value: f.object.coach.present? ? f.object.coach.profile_name : ''}
        coach.input :gender, label: '性别', as: :select, collection: [['男', 0], ['女', 1]], prompt: '请选择性别', selected: {value: f.object.coach.present? ? f.object.coach.profile_gender : ''}
        coach.input :address, label: '地址', input_html: {value: f.object.coach.present? ? f.object.coach.profile_address : ''}

        coach.input :target, label: '健身目标', input_html: {value: f.object.coach.present? ? f.object.coach.profile_target : ''}
        coach.input :skill, label: '擅长领域', input_html: {value: f.object.coach.present? ? f.object.coach.profile_skill : ''}
        coach.input :often, label: '常去场馆', input_html: {value: f.object.coach.present? ? f.object.coach.profile_often : ''}
        coach.input :interests, label: '健身兴趣', as: :check_boxes, multiple: true, collection: INTERESTS['items'].map { |item| [item['name'], item['id']] }
        coach.actions
      end
    end
    f.actions
  end

end
