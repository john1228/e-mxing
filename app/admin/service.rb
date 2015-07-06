ActiveAdmin.register Service do
  menu label: '服务号', priority: 2

  permit_params :identity, :name, :contact, :password, :avatar, :signature, :address, :hobby
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
    tabs do
      tab '0-订单' do
        render partial: 'order', locals: {
                                   coaches: service.coaches.map { |coach|
                                     coach.profile.name
                                   },
                                   g: service.coaches.map { |coach|
                                     g_course = coach.courses.where(guarantee: 1).pluck(:id)
                                     ids = OrderItem.where(course_id: g_course).pluck(:order_id)
                                     Order.where(id: ids, status: Order::STATUS[:pay]).sum(:pay_amount).to_i
                                   },
                                   n: service.coaches.map { |coach|
                                     g_course = coach.courses.where(guarantee: 0).pluck(:id)
                                     ids = OrderItem.where(course_id: g_course).pluck(:order_id)
                                     Order.where(id: ids, status: Order::STATUS[:pay]).sum(:pay_amount).to_i
                                   }
                               }
      end
      tab '1-预约' do
        render partial: 'appointment', locals: {
                                         coaches: service.coaches.map { |coach|
                                           coach.profile.name
                                         },
                                         all: service.coaches.map { |coach|
                                           coach.appointments.sum(:amount)
                                         },
                                         confirm: service.coaches.map { |coach|
                                           coach.appointments.where(status: Appointment::STATUS[:confirm]).sum(:amount)
                                         }
                                     }
      end
      tab '2-资料' do
        panel '详细资料' do
          attributes_table_for service do
            row('美型号') { service.profile.mxid }
            row('昵称') { service.profile.name }
            row('头像') { image_tag(service.profile.avatar.thumb.url, height: 70) }
            row('介绍') { truncate(service.profile.signature) }
            row('服务') { service.profile.interests_string }
            row('地址') { service.profile.address }
            row('联系电话') { service.profile.mobile }
          end
        end
      end
    end
  end

  sidebar '資源', only: :show do
    div do
      ul class: 'nav nav-pills nav-stacked' do
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

  sidebar '钱包', only: :show do
    wallet = service.wallet||service.create_wallet
    attributes_table_for wallet do
      row('余额') { "#{wallet.balance.round(2)}元" }
    end
    div do
      button '提现'
      button '转账'
    end
  end

  form partial: 'form'
end
