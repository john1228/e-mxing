module GroupAble
  extend ActiveSupport::Concern
  included do
    after_create :regist_to_easemob
    before_destroy :delete_group
    before_create :build_default_place

    has_many :group_photos, dependent: :destroy
    has_many :group_members, dependent: :destroy
    has_one :group_place, dependent: :destroy
  end


  private
  def regist_to_easemob
    easemob_token = Rails.cache.fetch('easemob')||init_easemob_token
    result = Faraday.post { |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = {groupname: name, desc: intro, public: true, maxusers: 100, approval: true, owner: "#{owner}"}.to_json.to_s
    }
    puts result.body
    self.easemob_id = JSON.parse(result.body).fetch('data').fetch('groupid')
    self.save
  end

  def delete_group
    easemob_token = Rails.cache.fetch('easemob')||init_easemob_token
    Faraday.delete do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/chatgroups/#{easemob_id}"
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
  end

  def init_easemob_token
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6HPZzIHIkEeSy6P9lvafoPA\", \"client_secret\": \"YXA6GQOgkrCoDL61TY9IPzRcto4mJn4\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    Rails.cache.write('easemob', easemob_body['access_token'], expires_in: 24*7*60*60)
    easemob_body['access_token']
  end

  def build_default_place
    if lng.blank? || lat.blank?
      owner_place = User.find_by_mxid(owner).place
      place = (owner_place.lonlat rescue nil)
    else
      place = "POINT(#{lng} #{lat})"
    end
    build_group_place(lonlat: place)
    true
  end
end