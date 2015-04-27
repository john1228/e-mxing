ActiveAdmin.register ServiceTrack do
  menu label: '团操'

  belongs_to :service
  navigation_menu :service

  permit_params :id, :track_type, :name, :intro, :address, :start, :during, :places, :free_places

  filter :begin, label: '开始时间'
  filter :track_type, label: '类型', as: :select, collection: Track::TYPE
  index title: '轨迹列表' do
    selectable_column
    column('类型') { |track| track.type_name }
    column('名字', :name)
    column('介绍') { |track| truncate(track.intro) }
    column('地址', :address)
    column('时间') { |track| track.start.strftime('%Y-%m-%d') }
    column('人數', :places)
    column('体验', :free_places)
    actions
  end


  show do
    tabs do
      tab '0-报名列表' do
        paginated_collection(service_track.appointments.includes(:user).page(params[:track_page]), param_name: :track_page) do
          table_for(collection, class: 'index_table') do
            column('美型号') { |appointment| appointment.user.profile_mxid }
            column('昵称') { |appointment| appointment.user.profile_name }
            column('头像') { |appointment| image_tag(appointment.user.profile_avatar.thumb.url, height: 70) }
            column('性别') { |appointment| appointment.user.profile_gender.eql?(1) ? '女' : '男' }
            column('签名') { |appointment| truncate(appointment.user.profile_signature) }
          end
        end
      end
      tab '1-添加报名' do

      end
    end
  end

  sidebar '轨迹详情', only: :show do
    attributes_table_for service_track do
      row('类型') { service_track.track_type_value }
      row('名称') { service_track.name }
      row('介绍') { service_track.intro }
      row('地址') { service_track.address }
      row('开始时间') { service_track.start.strftime('%Y-%m-%d %H:%M') }
      row('持续时间') { service_track.during }
      row('人數') { service_track.places }
      row('体验') { service_track.free_places }
    end
  end

  form partial: 'form'

  # form do |f|
  #   f.inputs '团操' do
  #     f.input :track_type, label: '类型', as: :select, collection: INTERESTS['items'].map { |item| [item['name'], item['id']] }, prompt: '请选择类型'
  #     f.input :coach_id, label: '教练', as: :select, collection: service.coaches.map { |coach| [coach.profile_name, coach.id] }, prompt: '请选择教练'
  #     f.input :name, label: '名称'
  #     f.input :intro, label: '介绍', input_html: {cols: 5, rows: 5}
  #     f.input :address, label: '地址'
  #     f.input :start, label: '开始时间', as: :string, input_html: {class: "hasDatetimePicker"}
  #     f.input :during, label: '持续时间'
  #     f.input :places, label: '人數'
  #     f.input :free_places, label: '体验'
  #   end
  #   f.actions
  # end
end
