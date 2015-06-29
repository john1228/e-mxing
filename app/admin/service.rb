ActiveAdmin.register Service do
  menu label: '服务号', priority: 2

  permit_params :identity, :name, :mobile, :password, :avatar, :signature, :address, :hobby
  filter :profile_name, label: '名称', as: :string
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
    column '服务号介绍' do |service|
      truncate(service.profile_signature)
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
    columns do
      column do
        render partial: 'order', locals: {
                                   coaches: (0...service.coaches.count).map { |index|
                                     [index, service.coaches[index].profile.name]
                                   },
                                   orders: (0...service.coaches.count).map { |index|
                                     [index, service.coaches[index].orders.count]
                                   }
                               }
      end
      column do
        render partial: 'appointment', locals: {
                                         n: service.coaches,
                                         g: service.coaches,
                                     }
      end

    end
  end

  sidebar '钱包', only: :show do
    div do
      ul class: 'nav nav-pills nav-stacked' do
        li role: 'presentation' do
          link_to('钱包', chat_with_service_path(service))
        end
        li role: 'presentation' do
          link_to('照片', admin_service_service_photos_path(service))
        end
        li role: 'presentation' do
          link_to('动态', admin_service_service_dynamics_path(service))
        end
        li role: 'presentation' do
          link_to('私教', admin_service_service_members_path(service))
        end
        li role: 'presentation' do
          link_to('聊天', chat_with_service_path(service))
        end
      end
    end
  end

  sidebar '資料', only: :show do
    attributes_table_for service do
      row('美型号') { service.profile_mxid }
      row('昵称') { service.profile_name }
      row('头像') { image_tag(service.profile_avatar.thumb.url, height: 70) }
      row('介绍') { truncate(service.profile_signature) }
      row('服务') { service.profile_interests_string }
      row('地址') { service.profile_address }
      row('联系电话') { service.mobile }
    end
  end

  form partial: 'form'
end
