ActiveAdmin.register Service do
  menu label: '服务号', priority: 2

  permit_params :identity, :name, :mobile, :password, :avatar, :signature, :address, :hobby
  filter :profile_name, label: '昵称', as: :string
  before_action :adjust, only: [:create, :update]

  controller do
    def adjust
      params[:service][:hobby].reject! { |item| item.blank? }
      params[:service][:hobby] = params[:service][:hobby].join(',')
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
    column '健身服务' do |service|
      truncate(service.profile_interests_string)
    end
    actions
  end

  controller do
    def chat
      @service = Service.find_by(id: params[:id])
      render layout: false
    end
  end

  show do
    div do
      panel '资源' do
        table style: 'width: 100%' do
          tr do
            td link_to('照片墙', admin_service_service_photos_path(service), class: :button)
            td link_to('动  态', admin_service_service_dynamics_path(service), class: :button)
            td link_to('团操', admin_service_service_tracks_path(service), class: :button)
            td link_to('旗下私教', admin_service_service_members_path(service), class: :button)
            td link_to('聊天', chat_with_service_path(service), class: :button)
          end
        end
      end
    end
  end

  sidebar '基本資料', only: :show do
    attributes_table_for service do
      row('美型号') { service.profile_mxid }
      row('昵称') { service.profile_name }
      row('头像') { image_tag(service.profile_avatar.thumb.url) }
      row('签名') { service.profile_signature }
      row('服务') { service.profile_interests_string }

    end
  end

  form partial: 'form'
end
