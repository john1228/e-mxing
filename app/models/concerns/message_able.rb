module MessageAble
  extend ActiveSupport::Concern

  def push(target, message)
    easemob_token = Rails.cache.fetch(:easemob_token)||init_easemob_token
    Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/messages'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body ={target_type: 'users', target: ["#{target.profile.mxid}"], msg: {type: 'txt', msg: message}}.to_json.to_s
    end
  end

  private
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