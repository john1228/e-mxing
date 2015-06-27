module ProfileAble
  extend ActiveSupport::Concern
  included do
    after_create :regist_to_easemob
  end
  private
  def regist_to_easemob
    easemob_token = Rails.cache.fetch(:easemob_token)||init_easemob_token
    Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"username\": \"#{mxid}\", \"password\": \"123456\", \"nickname\": \"#{name}\"}"
    end

    Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/messages'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body ={target_type: 'users', target: ['mxid'], msg: {type: 'txt', msg: '欢迎加入美型'}}.to_json.to_s
    end
  end

  def init_easemob_token
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6HPZzIHIkEeSy6P9lvafoPA\", \"client_secret\": \"YXA6GQOgkrCoDL61TY9IPzRcto4mJn4\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    Rails.cache.write('easemob', easemob_body['access_token'], expires_in: 24*5*60*60)
    easemob_body['access_token']
  end

end