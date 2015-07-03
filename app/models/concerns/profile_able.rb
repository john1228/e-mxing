module ProfileAble
  extend ActiveSupport::Concern
  included do
    after_create :regist_to_easemob
  end
  private
  def regist_to_easemob
    easemob_token = Rails.cache.fetch(:easemob_token)||init_easemob_token
    Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/users'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"username\": \"#{mxid}\", \"password\": \"123456\", \"nickname\": \"#{name}\"}"
    end

    Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/messages'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body ={target_type: 'users', target: ["#{mxid}"], msg: {type: 'txt', msg: '欢迎您加入国内首家线上健身社交平台。
\n 美型拥有庞大的运动健身场地，并且展示驻地私教，您可用根据自己到运动健身需求选择对应的运动健身课程。
\n 分享与动圈动态，来“约”更多型男美女，让运动健身不再孤单。
\n【美型】2.0全线上线，运动健身哪家墙，卖课“约”课美型强'}}.to_json.to_s
    end
  end

  def init_easemob_token
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6NQmy0PIkEeSQO18Yeq100Q\", \"client_secret\": \"YXA6t1SdtNrJAAHq6m3Bu3Yx1Ryr8jI\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    Rails.cache.write('easemob', easemob_body['access_token'], expires_in: 24*5*60*60)
    easemob_body['access_token']
  end

end