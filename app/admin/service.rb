ActiveAdmin.register Service do
  menu label: '服务号', if: proc { !current_admin_user.role.eql?(AdminUser::ROLE[:service]) }

  permit_params :mobile, :sns, :identity, :name, :contact, :password, :avatar, :signature, :address, interest: [], service: []
  filter :profile_name, label: '名称', as: :string
  before_action :adjust, only: [:create, :update]

  csv do
    column('美型号') { |service| service.profile.mxid }
    column('地区') { |service| service.profile.address[0, service.profile.address.index('市')] rescue '' }
    column('名称') { |service| service.profile.name }
    column('服务项目') { |service| service.profile.interests_string }
    column('地址') { |service| service.profile.address }
    column('联系方式') { |service| service.profile.mobile }
  end

  controller do
    def adjust
      params[:service][:interests] = (params[:service][:interest].join(',') rescue '')
    end
  end


  index title: '服务号' do
    column '美型号' do |service|
      link_to("#{service.profile.mxid}", admin_service_path(service))
    end
    column '昵称' do |service|
      link_to("#{service.profile.name}", admin_service_path(service))
    end
    column '头像' do |service|
      link_to(image_tag(service.profile.avatar.thumb.url, height: 70), admin_service_path(service))
    end
    column '健身服务' do |service|
      truncate(service.profile.interests_string)
    end
    column '服务号介绍' do |service|
      truncate(service.profile.signature)
    end
    actions
  end

  controller do
    def chat
      @service = Service.find_by(id: params[:id])
      render layout: false
    end

    def withdraw
      @service = Service.find_by(id: params[:id])
      render layout: false
    end

    def withdraw_result
      service = Service.find_by(id: params[:id])
      withdraw = Withdraw.new(coach_id: service.id, name: params[:name], account: params[:account], amount: params[:amount])
      if withdraw.save
        @errors = nil
      else
        @errors = withdraw.errors.messages
      end
      render layout: false
    end

    def transfer
      @service = Service.find_by(id: params[:id])
      render layout: false
    end

    def transfer_result
      service = Service.find_by(id: params[:id])
      coach = service.coaches.find_by(id: params[:coach])
      coach_wallet = Wallet.find_or_create_by(user: coach)
      service_wallet = Wallet.find_or_create_by(user: service)
      begin
        coach_wallet.with_lock do
          coach_wallet.balance = coach_wallet.balance + BigDecimal(params[:amount])
          coach_wallet.action = WalletLog::ACTIONS['转账']
          coach_wallet.save
        end
        service_wallet.with_lock do
          service_wallet.balance = service_wallet.balance - BigDecimal(params[:amount])
          service_wallet.action = WalletLog::ACTIONS['转账']
          service_wallet.save
        end
      rescue Exception => exp
        @errors = exp.message
      end
      render layout: false
    end

    def message
      service = Service.find_by(id: params[:id])
      case params[:target].to_i
        when 1
          #全部推送消息
          order_users = Order.includes(:user).where(service_id: service.id, status: Order::STATUS[:pay]).map { |item| item.user.profile.mxid }
          follow_users = Follow.includes(:user).where(service_id: service.id).map { |item| item.user.profile.mxid }
          PushMessageJob.perform_later(service.profile.mxid, (order_users+follow_users).uniq, params[:message])
        when 2
          #购课需要推送消息
          order_users = Order.includes(:user).where(service_id: service.id, status: Order::STATUS[:pay]).map { |item| item.user.profile.mxid }
          PushMessageJob.perform_later(service.profile.mxid, order_users, params[:message])
        when 3
          #扫码推送消息
          follow_users = Follow.includes(:user).where(service_id: service.id).map { |item| item.user.profile.mxid }
          PushMessageJob.perform_later(service.profile.mxid, follow_users, params[:message])
      end
      redirect_to admin_service_path(service), alert: '消息已发送'
    end
  end

  show do
    tabs do
      tab '0-账户余额' do
        panel '账户余额' do
          wallet = service.wallet||service.create_wallet
          div class: 'attributes_table' do
            table do
              tr do
                th '余额'
                td "#{wallet.balance}元"
              end
              tr do
                th do
                  link_to('提现', withdraw_path(service), class: 'fancybox button', data: {'fancybox-type' => 'ajax'}) if authorized?(:withdraw, service)
                end
                td do
                  link_to('转账', transfer_path(service), class: 'fancybox button', data: {'fancybox-type' => 'ajax'}) if authorized?(:transfer, service)
                end
              end
            end
          end
        end
      end
      tab '1-订单' do
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
      tab '2-预约' do
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
      tab '3-资料' do
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

      tab '4-消息群发' do
        render partial: 'message'
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
        li role: 'presentation' do
          link_to('修改密码', edit_admin_admin_user_path(current_admin_user))
        end
      end
    end
  end

  form partial: 'form'
end
