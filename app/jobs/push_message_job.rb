class PushMessageJob < ActiveJob::Base
  queue_as :default

  def perform(target, message)
    access_token = Rails.cache.fetch('mob')
    if target.eql?('all')
      user = Profile.where.not(identity: 2)
      (0..(user.size/20)).map { |index|
        mxids = user.page(index+1).pluck(:id).map { |id| "#{Profile::BASE_NO + id}" }
        resp = Faraday.post do |req|
          req.url "#{MOB['host']}/messages"
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Bearer #{access_token}"
          req.body = {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}}.to_json.to_s
        end
        puts resp.body
        sleep(0.1)
      }
    else
      user = target.split(',')
      (0..(user.size/2)).map { |index|
        mxids = user[index*20, 20]
        resp = Faraday.post do |req|
          req.url "#{MOB['host']}/messages"
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Bearer #{access_token}"
          req.body = {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}}.to_json.to_s
        end
        puts resp.body
        sleep(0.1)
      }
    end


  end
end
