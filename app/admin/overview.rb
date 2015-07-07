ActiveAdmin.register Overview do
  menu label: '数据概况', parent: '应用数据'
  config.batch_actions = false
  actions :index
  filter :report_date, label: '报告日期'
  index do
    column('报告日期') { |overview| overview.report_date.strftime('%Y-%m-%d') }
    column '激活用户', :activation
    column '注册用户', :register
    column '活跃用户', :activity
  end
end
