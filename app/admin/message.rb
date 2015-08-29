ActiveAdmin.register_page 'Message' do
  menu label: '消息', parent: '运营'
  content title: '消息' do
    render partial: 'message'
  end
  controller do
    def push
      PushMessageJob.perform_later('mxing', params[:users], params[:message])
      redirect_to admin_message_path, alert: '推送消息已放入消息队列开始推送'
    end
  end
end
