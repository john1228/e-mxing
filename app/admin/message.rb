ActiveAdmin.register_page 'Message' do
  menu label: '消息', parent: '运营'
  content title: '消息' do
    render partial: 'message'
  end
  controller do
    def push
      if params[:users].eql?('all')
        mxids = Profile.where.not(identity: 2).pluck(:id).map { |id| Profile::BASE_NO + id }
      else
        mxids = params[:users].split(',')
      end
      (0..(mxids.size/20)).map { |index|
        message(mxids[index*20, 20-1], params[:message])
        sleep(0.1)
      }
      redirect_to admin_message_path, alert: '推送完成'
    end

    private
    def message(mxids, message)
      easemob_token = Rails.cache.fetch(:easemob_token)||init_easemob_token
      Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/messages'
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{easemob_token}"
        req.body ={target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}}.to_json.to_s
      end
    end

    def init_easemob_token
      token_response = Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
        req.headers['Content-Type'] = 'application/json'
        req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6NQmy0PIkEeSQO18Yeq100Q\", \"client_secret\": \"YXA6t1SdtNrJAAHq6m3Bu3Yx1Ryr8jI\"}"
      end
      easemob_body = JSON.parse(token_response.body)
      Rails.cache.write('easemob', easemob_body['access_token'], expires_in: 24*5*60*60)
      easemob_body['access_token']
    end
  end
end
