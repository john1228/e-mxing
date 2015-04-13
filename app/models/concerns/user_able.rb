module UserAble
  extend ActiveSupport::Concern
  included do
    after_create :regist_to_easemob
    before_create :build_default_profile
    before_save :encrypted_password

    has_one :profile, dependent: :destroy
    delegate :mxid, :name, :avatar, :signature, :gender, :birthday, :address, :target, :skill, :often, :interests, to: :profile, prefix: true, allow_nil: false

    has_many :photos, dependent: :destroy
    has_many :dynamics, dependent: :destroy
    has_many :dynamic_comments, dependent: :destroy
    has_many :tracks, dependent: :destroy
    has_many :group_members, dependent: :destroy
    has_many :appointments, dependent: :destroy
    has_one :place, dependent: :destroy
    has_many :service_members, dependent: :destroy
  end

  private
  def build_default_profile
    if avatar.blank?
      build_profile(name: name, remote_avatar_url: remote_avatar_url, gender: gender, birthday: birthday.blank? ? Date.today.prev_year(15) : birthday, identity: identity.to_i, mobile: mobile)
    else
      build_profile(name: name, avatar: avatar, gender: gender, birthday: birthday.blank? ? Date.today.prev_year(15) : birthday, identity: identity.to_i, mobile: mobile)
    end
    true
  end

  def encrypted_password
    salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
    self.salt = salt_arr.sample(18).join
    self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
  end

  def regist_to_easemob
    easemob_token = Rails.cache.fetch(:easemob_token)||init_easemob_token
    Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"username\": \"#{username}\", \"password\": \"123456\", \"nickname\": \"#{profile.name}\"}"
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
end