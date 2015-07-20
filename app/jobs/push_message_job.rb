class PushMessageJob < ActiveJob::Base
  queue_as :default

  def perform(target, message)
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6NQmy0PIkEeSQO18Yeq100Q\", \"client_secret\": \"YXA6t1SdtNrJAAHq6m3Bu3Yx1Ryr8jI\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    easemob_token = easemob_body['access_token']
    (0..(target.size/20)).map { |index|
      Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/messages'
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{easemob_token}"
        req.body = {target_type: 'users', target: target[index*20, 20-1], msg: {type: 'txt', msg: message}}.to_json.to_s
      end
      sleep(0.1)
    }
  end
end
