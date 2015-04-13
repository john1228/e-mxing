ActiveAdmin.register Track do
  menu label: '运动轨迹'
  belongs_to :user
  navigation_menu :user


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
      row('名称') { |track| track.name } if user.is_coach?||user.is_service?
      row('介绍') { |track| track.intro } if user.is_coach?||user.is_service?
      row('地址') { |track| track.address } if user.is_coach?||user.is_service?
      row('开始时间') { |track| track.start.strftime('%Y-%m-%d %H:%M') }
      row('持续时间') { |track| track.during }
      row('人數') { |track| track.places } if user.is_coach?||user.is_service?
      row('体验') { |track| track.free_places } if user.is_coach?||user.is_service?
    end
  end

  form do |f|
    f.inputs '添加运动轨迹' do
      f.input :user_id, as: :hidden
      f.input :track_type, label: '类型', as: :select, collection: Track::TYPE, prompt: '请选择'
      f.input :name, label: '名称' if f.object.user.is_coach?||f.object.user.is_service?
      f.input :intro, label: '介绍', input_html: {cols: 5, rows: 5} if f.object.user.is_coach?||f.object.user.is_service?
      f.input :address, label: '地址' if f.object.user.is_coach?||f.object.user.is_service?
      f.input :start, label: '开始时间', as: :string
      f.input :during, label: '持续时间'
      f.input :places, label: '人數' if f.object.user.is_coach?||f.object.user.is_service?
      f.input :free_places, label: '体验' if f.object.user.is_coach?||f.object.user.is_service?
    end
    f.actions
  end
end
