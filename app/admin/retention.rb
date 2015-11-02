ActiveAdmin.register Retention do
  menu label: '留存率', parent: '应用数据'
  config.batch_actions = false
  actions :index
  filter :report_date, label: '报告日期'
  index do
    column('报告日期') { |retention| retention.report_date.strftime('%Y-%m-%d') }
    column '注册人数', :register
    column '次日留存率', :day_one
    column '三日留存率', :day_three
    column '七日留存率', :day_seven
  end
end
