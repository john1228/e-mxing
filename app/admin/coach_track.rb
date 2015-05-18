ActiveAdmin.register CoachTrack do
  menu label: '轨迹'
  belongs_to :coach
  navigation_menu :coach

  permit_params :id, :coach_id, :track_type, :name, :intro, :address, :start, :during, :places, :free_places

  filter :begin, label: '开始时间'
  filter :track_type, label: '类型', as: :select, collection: INTERESTS['items'].map { |item| [item['name'], item['id']] }
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
        paginated_collection(coach_track.appointments.includes(:user).page(params[:track_page]), param_name: :track_page) do
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
    attributes_table_for coach_track do
      row('类型') { coach_track.type_name }
      row('名称') { coach_track.name }
      row('介绍') { coach_track.intro }
      row('地址') { coach_track.address }
      row('开始时间') { coach_track.start.strftime('%Y-%m-%d %H:%M') }
      row('持续时间') { coach_track.during }
      row('人數') { coach_track.places }
      row('体验') { coach_track.free_places }
    end
  end

  form partial: 'form'
end
