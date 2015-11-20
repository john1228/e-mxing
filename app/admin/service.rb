ActiveAdmin.register Service do
  menu label: '工作室', priority: 2, if: proc { !current_admin_user.role.eql?(AdminUser::ROLE[:service]) }
  config.batch_actions = false

  permit_params :mobile, :sns, profile_attributes: [:id, :name, :avatar, :auth, :signature, :province, :city, :area, :address, :identity, :mobile, hobby: [], service: []]
  filter :profile_name, label: '名称', as: :string


  csv do
    column('美型号') { |service| service.profile.mxid }
    column('地区') { |service| service.profile.address[0, service.profile.address.index('市')] rescue '' }
    column('名称') { |service| service.profile.name }
    column('服务项目') { |service| service.profile.interests_string }
    column('地址') { |service| service.profile.address }
    column('联系方式') { |service| service.profile.mobile }
    column('照片数量') { |service| service.photos.count }
    column('私教数量') { |service| service.coaches.count }
    column('私教信息') { |service| service.coaches.map { |coach| "#{coach.profile.name}(#{coach.profile.mxid})" } }
    column('课程数量') { |service| Sku.where(seller_id: service.coaches.pluck(:id)<< service.id).count }
    column('注册日期') { |service| service.created_at.localtime.strftime('%Y-%m-%d') }
  end

  actions :index, :new, :create, :edit, :update, :show
  scope('0-认证工作室', :authorized, default: true)
  scope('1-未认证工作室', :unauthorized)

  index do
    selectable_column
    column '美型号' do |service|
      link_to("#{service.profile.mxid}", admin_service_path(service))
    end
    column '昵称' do |service|
      link_to("#{service.profile.name}", admin_service_path(service))
    end
    column '头像' do |service|
      link_to(image_tag(service.profile.avatar.url, height: 70), admin_service_path(service))
    end
    column '健身服务' do |service|
      truncate(service.profile.interests_string)
    end
    column '服务号介绍' do |service|
      truncate(service.profile.signature)
    end
    actions do |service|
      link_to_modal "标签", mark_service_path(service), rel: 'model:open'
    end
  end

  controller do
    def new
      @service = Service.new
      @service.build_profile
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

    def mark
      @service = Service.find(params[:id])
      render layout: false
    end

    def mark_result
      service = Service.find(params[:id])
      service.profile.update(tag: params[:tag])
      edirect_to collection_path, alert: '标记成功'
    end
  end

  show do
    render 'show', locals: {balance: (service.wallet.balance.to_i rescue 0), profile: service.profile}
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
