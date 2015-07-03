module GroupMemberAble
  extend ActiveSupport::Concern
  included do
    after_create :add_member
    before_destroy :delete_member

    belongs_to :group
    belongs_to :user
  end

  def add_member
    easemob_token = Rails.cache.fetch('easemob')||init_easemob_token
    Faraday.post do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxingsijiao/chatgroups/#{group.easemob_id}/users/#{user.mxid}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
  end

  def delete_member
    easemob_token = Rails.cache.fetch('easemob')||init_easemob_token
    Faraday.delete do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxingsijiao/chatgroups/#{group.easemob_id}/users/#{user.mxid}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
  end


  private
  def init_easemob_token
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxingsijiao/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6NQmy0PIkEeSQO18Yeq100Q\", \"client_secret\": \"YXA6t1SdtNrJAAHq6m3Bu3Yx1Ryr8jI\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    Rails.cache.write('easemob', easemob_body['access_token'], expires_in: 24*7*60*60)
    easemob_body['access_token']
  end
end