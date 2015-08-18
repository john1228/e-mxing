class PushMessageJob < ActiveJob::Base
  queue_as :default

  def perform(target, message)
    access_token = Rails.cache.fetch('mob')
    (0..(target.size/20)).map { |index|
      resp = Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/messages'
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{access_token}"
        req.body = {target_type: 'users', target: target[index*20, 20-1], msg: {type: 'txt', msg: message}}.to_json.to_s
      end
      puts resp.body
      sleep(0.1)
    }
  end
end
