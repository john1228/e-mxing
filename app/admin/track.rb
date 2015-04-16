ActiveAdmin.register Track do
  menu label: '运动轨迹'
  belongs_to :enthusiast
  navigation_menu :enthusiast


  permit_params :user_id, :track_type, :name, :intro, :address, :start, :during, :places, :free_places

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

  show title: '轨迹详情' do
    attributes_table do
      row('类型') { |track| track.track_type_value }
      row('名称') { |track| track.name }
      row('介绍') { |track| track.intro }
      row('地址') { |track| track.address }
      row('开始时间') { |track| track.start.strftime('%Y-%m-%d %H:%M') }
      row('持续时间') { |track| track.during }
      row('人數') { |track| track.places }
      row('体验') { |track| track.free_places }
    end
  end

  form do |f|
    f.inputs '添加运动轨迹' do
      f.input :user_id, as: :hidden
      f.input :track_type, label: '类型', as: :select, collection: INTERESTS['items'].map { |item| [item['name'], item['id']] }, prompt: '请选择'
      f.input :start, label: '开始时间', as: :string
      f.input :during, label: '持续时间'
    end
    f.actions
  end
end
