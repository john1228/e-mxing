ActiveAdmin.register Service do
  menu label: '服务号', priority: 2

  permit_params :identity, :name, :username, :password, :avatar, :signature, :address, :interests => []
  filter :profile_name, label: '昵称', as: :string
  before_action :adjust, only: [:create, :update]

  controller do
    def adjust
      params[:service][:interests].reject! { |item| item.blank? }
      params[:service][:interests] = params[:service][:hobby].join(',')
    end
  end


  index title: '服务号' do
    column '美型号' do |service|
      link_to("#{service.profile_mxid}", admin_service_path(service))
    end
    column '昵称' do |service|
      link_to("#{service.profile_name}", admin_service_path(service))
    end
    column '头像' do |service|
      link_to(image_tag(service.profile_avatar.thumb.url, height: 70), admin_service_path(service))
    end
    column '简介' do |service|
      truncate(service.profile_signature)
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


  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs '资料' do
      f.input :username, as: :hidden, input_html: {value: SecureRandom.uuid}
      f.input :name, label: '昵称', input_html: {value: (f.object.profile_name rescue '')}
      f.input :avatar, label: '头像', as: :file
      f.input :signature, label: '简介', input_html: {value: (f.object.profile_signature rescue '')}
      f.input :address, label: '地址', input_html: {value: (f.object.profile_address rescue '')}

      f.input :interests, label: '健身服务', as: :check_boxes, collection: INTERESTS['items'].map { |item| [item['name'], item['id']] }
      f.input :identity, as: :hidden, input_html: {value: 2}
    end
    f.actions
  end
end
