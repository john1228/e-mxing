ActiveAdmin.register ServiceMember do
  menu label: '私教'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  permit_params :service_id,
                coach_attributes: [:id, :mobile, :password, :signature, :name, :avatar, :gender, :identity, :birthday,
                                   :address, :target, :skill, :often, :hobby]
  before_filter :adjust, only: :create
  before_filter :update_coach, only: :update
  controller do
    def adjust
      params[:service_member][:coach_attributes][:hobby].reject! { |item| item.blank? }
      params[:service_member][:coach_attributes][:hobby] = params[:service_member][:coach_attributes][:hobby].join(',')
    end

    def update_coach
      params[:service_member][:coach_attributes][:hobby].reject! { |item| item.blank? }
      avatar = params[:service_member][:coach_attributes][:avatar]
      member = ServiceMember.find_by(id: params[:id])
      coach = member.coach
      update_params = {
          name: params[:service_member][:coach_attributes][:name],
          birthday: params[:service_member][:coach_attributes][:birthday],
          address: params[:service_member][:coach_attributes][:address],
          target: params[:service_member][:coach_attributes][:target],
          skill: params[:service_member][:coach_attributes][:target],
          often: params[:service_member][:coach_attributes][:target],
          hobby: params[:service_member][:coach_attributes][:hobby].join(',')
      }
      update_params = update_params.merge(avatar: avatar) unless avatar.blank?
      coach.update(update_params)
    end
  end

  index title: '旗下私教' do
    selectable_column
    column '昵称' do |member|
      "#{member.coach.profile.name}"
    end
    column '头像' do |member|
      image_tag("#{member.coach.profile.avatar.thumb.url}", height: 70)
    end
    column '签名' do |member|
      truncate(member.coach.profile.signature)
    end
    actions
  end
  show title: '私教' do
    coach = service_member.coach
    tabs do
      tab '0-订单' do
        paginated_collection(coach.orders.page(params[:order_page]), param_name: 'order_page') do
          table_for collection, class: 'index_table' do
            column('订单号', :no)
            column('课程') { |order| order.order_item.name }
            column('数量') { |order| order.order_item.amount }
            column('下单时间') { |order| order.created_at.strftime('%Y-%m-%d %H:%M:%S') }
          end
        end
      end
      tab '1-预约' do
        paginated_collection(coach.appointments.page(params[:appoint_page]), param_name: 'appoint_page') do
          table_for collection, class: 'index_table' do
            column('预约单号', :id)
            column('课程') { |appointment| appointment.course.name }
            column('课时', :amount)
            column('状态') { |appointment|
              case appointment.status
                when Appointment::STATUS[:cancel]
                  '已取消'
                when Appointment::STATUS[:waiting]
                  '待确认'
                when Appointment::STATUS[:confirm]
                  '已确认'
                when Appointment::STATUS[:finish]
                  '已评价'
              end
            }
          end
        end
      end
      tab '2-课程' do
        paginated_collection(coach.courses.page(params[:course_page]), param_name: 'course_page') do
          table_for collection, class: 'index_table' do
            column('课程', :name)
            column('类型', :type)
            column('教学方式', :style)
            column('时长', :during)
            column('价格', :price)
          end
        end
      end
    end
  end

  sidebar '私教信息', only: :show do
    attributes_table_for service_member do
      row('登录名') { service_member.coach.mobile }
      row('昵称') { service_member.coach.profile.name }
      row('头像') { image_tag(service_member.coach.profile.avatar.thumb.url, height: 70) }
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
