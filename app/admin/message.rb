ActiveAdmin.register_page 'Message' do
  menu label: '消息', parent: '运营'
  content title: '消息' do
    render partial: 'message'
  end
  controller do
    def push
      if params[:users].eql?('all')
        mxids = Profile.where.not(identity: 2).pluck(:id).map { |id| "#{Profile::BASE_NO + id}" }
      else
        mxids = params[:users].split(',')
      end
      PushMessageJob.perform_later(mxids, params[:message])
      redirect_to admin_message_path, alert: '推送消息已放入消息队列开始推送'
    end
  end
end
