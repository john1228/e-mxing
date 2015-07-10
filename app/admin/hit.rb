ActiveAdmin.register Hit do
  menu label: '点击'

  index do
    column('点击日期') { |hit| hit.date.strftime('%Y-%m-%d') }
    column('设备', :device)
    column('点击点', :point)
    column('点击数', :number)
  end

end
