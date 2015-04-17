ActiveAdmin.register ServiceMember, :name_space => :user do
  menu label: '私教'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  permit_params :member_username, :member_password, :member_name, :member_avatar, :member_gender, :member_signature, :member_birthday,
                :member_address, :member_target, :member_skill, :member_stadium, :member_interests, :member_identity
  index title: '旗下私教' do
    selectable_column
    column '昵称' do |member|
      link_to("#{member.coach.profile_name}", '')
    end
    column '头像' do |member|
      image_tag(member.coach.profile_avatar.thumb.url, height: 70)
    end
    column '签名' do |member|
      truncate(member.coach.profile_signature)
    end
    actions
  end

  show do
    attributes_table do

    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs '登录信息' do
      f.input :member_username, label: '登录名', as: :phone, input_html: {value: f.object.coach.nil? ? '' : f.object.coach.username}, hint: content_tag(:span, '手机号码', style: 'color:red')
      f.input :member_password, label: '密码', as: :password
    end
    f.inputs '资料' do
      f.input :member_name, label: '昵称', input_html: {value: f.object.coach.nil? ? '' : f.object.coach.profile_name}
      f.input :member_avatar, label: '头像', as: :file
      f.input :member_birthday, label: '生日', as: :datepicker, input_html: {value: f.object.coach.nil? ? '' : f.object.coach.profile_birthday}
      f.input :member_address, label: '地址', input_html: {value: f.object.coach.nil? ? '' : f.object.coach.profile_address}

      f.input :member_target, label: '健身目标', input_html: {value: f.object.coach.nil? ? '' : f.object.coach.profile_target}
      f.input :member_skill, label: '擅长领域', input_html: {value: f.object.coach.nil? ? '' : f.object.coach.profile_skill}
      f.input :member_stadium, label: '常去场馆', input_html: {value: f.object.coach.nil? ? '' : f.object.coach.profile_often}
      f.input :member_interests, label: '健身兴趣', as: :check_boxes, multiple: true, collection: INTERESTS['items'].map { |item| [item['name'], item['id']] }
      f.input :member_identity, as: :hidden, input_html: {value: 1}
    end

    f.submit('确定')
  end

end
