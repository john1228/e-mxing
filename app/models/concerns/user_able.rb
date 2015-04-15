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
    if avatar.is_a?(String)
      build_profile(name: name,
                    remote_avatar_url: avatar,
                    gender: gender,
                    signature: signature||'这家伙很懒,什么也没留下',
                    identity: identity||0,
                    birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                    address: address||'',
                    target: target||'',
                    skill: skill||'',
                    often: often||'',
                    interests: interests||'',
                    mobile: mobile||'')
    else
      build_profile(name: name,
                    avatar: avatar,
                    gender: gender,
                    signature: signature||'这家伙很懒,什么也没留下',
                    identity: identity||0,
                    birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                    address: address||'',
                    target: target||'',
                    skill: skill||'',
                    often: often||'',
                    interests: interests||'',
                    mobile: mobile||'')
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
    result =Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"username\": \"#{profile_mxid}\", \"password\": \"123456\", \"nickname\": \"#{profile_name}\"}"
    end
    puts result.body
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