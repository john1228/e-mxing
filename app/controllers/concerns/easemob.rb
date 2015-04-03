module Easemob
  extend ActiveSupport::Concern

  def regist_single(username, nickname)
    easemob_token = session[:easemob].blank? ? '' : session[:easemob]
    if easemob_token.blank?
      token_response = Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
        req.headers['Content-Type'] = 'application/json'
        req.body = '{"grant_type": "client_credentials", "client_id": "YXA6HPZzIHIkEeSy6P9lvafoPA", "client_secret": "YXA6GQOgkrCoDL61TY9IPzRcto4mJn4"}'
      end
      easemob_body = JSON.parse(token_response.body)
      easemob_token = easemob_body['access_token']
      session[:easemob] = easemob_token
    end

    response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"username\": \"#{username}\", \"password\": \"123456\", \"nickname\": \"#{nickname}\"}"
    end
    result = JSON(response.body)
    logger.info "result:#{result}"
  end

  def update_nickname(username, new_name)
    easemob_token = session[:easemob].blank? ? '' : session[:easemob]
    if easemob_token.blank?
      token_response = Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
        req.headers['Content-Type'] = 'application/json'
        req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6HPZzIHIkEeSy6P9lvafoPA\", \"client_secret\": \"YXA6GQOgkrCoDL61TY9IPzRcto4mJn4\"}"
      end
      easemob_body = JSON.parse(token_response.body)
      easemob_token = easemob_body['access_token']
      session[:easemob] = easemob_token
    end
    Faraday.post do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/users/#{username}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"nickname\": \"#{new_name}\"}"
    end
  end


  def friends_list(owner)
    easemob_token = session[:easemob].blank? ? '' : session[:easemob]
    if easemob_token.blank?
      token_response = Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
        req.headers['Content-Type'] = 'application/json'
        req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6HPZzIHIkEeSy6P9lvafoPA\", \"client_secret\": \"YXA6GQOgkrCoDL61TY9IPzRcto4mJn4\"}"
      end
      easemob_body = JSON.parse(token_response.body)
      easemob_token = easemob_body['access_token']
      session[:easemob] = easemob_token
    end
    response = Faraday.get do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/users/#{owner}/contacts/users"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
    friends = JSON(response.body)["data"]
  end
end