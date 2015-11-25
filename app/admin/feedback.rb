ActiveAdmin.register Feedback do
  menu label: '反馈', parent: '反馈与举报'

  actions :index


  index do
    selectable_column
    column('反馈人') { |feedback| feedback.user.profile.name rescue '' }
    column('联系方式', :contact)
    column('反馈内容') { |feedback| truncate(feedback.content) }
    column('反馈时间') { |feedback| feedback.created_at.strftime("%Y-%m-%d %H:%M:%S") }
  end
end
