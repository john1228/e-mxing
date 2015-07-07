ActiveAdmin.register Overview do
  menu label: '数据概况', parent: '应用数据'
  config.batch_actions = false
  actions :index
  filter :report_date, label: '报告日期'
  index as: :blog do
    title :report_date
    body :register
  end
end
