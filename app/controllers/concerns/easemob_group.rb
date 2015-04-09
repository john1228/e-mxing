module EasemobGroup
  extend ActiveSupport::Concern

  def create_group(name, desc, owner)
    easemob_token = Rails.cache.fetch(:easemob_token)
    if easemob_token.blank?
      easemob_token = get_easemob_token
      Rails.cache.write(:easemob_token, easemob_token, expires_in: 24*7*60*60)
    end
    result = Faraday.post do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = {groupname: name, desc: desc, public: true,
                  maxusers: 100, approval: true, owner: owner}.to_json
    end
    JSON.parse(result.body).fetch('data').fetch('groupid')
  end

  def update_group(desc)
    easemob_token = Rails.cache.fetch(:easemob_token)
    if easemob_token.blank?
      easemob_token = get_easemob_token
      Rails.cache.write(:easemob_token, easemob_token, expires_in: 24*7*60*60)
    end
    Faraday.put do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = {desc: desc}.to_json
    end
  end

  def delete_group(group_id)
    easemob_token = Rails.cache.fetch(:easemob_token)
    if easemob_token.blank?
      easemob_token = get_easemob_token
      Rails.cache.write(:easemob_token, easemob_token, expires_in: 24*7*60*60)
    end
    Faraday.delete do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups/#{group_id}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = {desc: desc}.to_json
    end
  end

  def add_member(group_id, mxid)
    easemob_token = Rails.cache.fetch(:easemob_token)
    if easemob_token.blank?
      easemob_token = get_easemob_token
      Rails.cache.write(:easemob_token, easemob_token, expires_in: 24*7*60*60)
    end
    Faraday.post do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups/#{group_id}/users/#{mxid}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
  end

  def remove_member(group_id, mxid)
    easemob_token = Rails.cache.fetch(:easemob_token)
    if easemob_token.blank?
      easemob_token = get_easemob_token
      Rails.cache.write(:easemob_token, easemob_token, expires_in: 24*7*60*60)
    end
    Faraday.delete do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups/#{group_id}/users/#{mxid}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
  end


  private
  def get_easemob_token
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6HPZzIHIkEeSy6P9lvafoPA\", \"client_secret\": \"YXA6GQOgkrCoDL61TY9IPzRcto4mJn4\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    easemob_body['access_token']
  end
end