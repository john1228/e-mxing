ActiveAdmin.register Online do
  menu label: '在线'
  index do
    column('打开日期') { |online| online.date.strftime('%Y-%m-%d') }
    column('设备', :device)
    column('打开时间') { |online| online.open.strftime('%Y-%m-%d %H:%M:%S') }
    column('关闭时间') { |online| online.close.strftime('%Y-%m-%d %H:%M:%S') }
  end
end
