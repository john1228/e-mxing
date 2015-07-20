ActiveAdmin.register Device do
  menu label: '激活设备', parent: '原始数据'
  actions :index

  index do
    column('设备名称', :name)
    column('设备系统', :system)
    column('设备码', :device)
    column('渠道', :channel)
    column('应用版本', :version)
    column('激活时间') { |device| device.created_at.strftime('%Y-%m-%d %H:%M:%S') }
  end

end
