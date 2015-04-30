ActiveAdmin.register Report do
  menu label: '举报'
  actions :index
  index do
    selectable_column
    column('举报人') { |report| report.user.profile_name }
    column('举报类型', :report_type)
    column('被举报者') { |report| report.report_id }
    column('举报内容') { |report| truncate(report.content) }
    column('举报时间') { |report| report.created_at.strftime("%Y-%m-%d %H:%M:%S") }
  end
end
