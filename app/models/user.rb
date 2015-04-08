class User < ActiveRecord::Base
  scope :fan, -> { where(id: Profile.where(identity: 0).pluck(:user_id)) }
  scope :coach, -> { where(id: Profile.where(identity: 1).pluck(:user_id)) }
  scope :service, -> { where(id: Profile.where(identity: 2).pluck(:user_id)) }

  validates_presence_of :username, message: '用户名不能为空'
  validates_uniqueness_of :username, message: '用戶已注册'

  has_one :profile, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :dynamics, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :service_members
  has_one :place

  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  attr_accessor :remote_avatar_url
  attr_accessor :name
  attr_accessor :gender
  attr_accessor :birthday
  attr_accessor :avatar
  attr_accessor :identity

  before_create :build_default_profile
  before_save :encrypted_password


  def token
    Digest::MD5.hexdigest("#{id}")
  end


  def is_coach?
    profile.identity.eql?(1)
  end

  def is_service?
    profile.identity.eql?(2)
  end

  def summary_json
    json = profile.summary_json
    json[:token] = token
    json
  end

  def mxid
    profile.mxid
  end


  private
  def build_default_profile
    if avatar.blank?
      build_profile(name: name, remote_avatar_url: remote_avatar_url, gender: gender, birthday: birthday.blank? ? Date.today.prev_year(15) : birthday, identity: identity.to_i)
    else
      build_profile(name: name, avatar: avatar, gender: gender, birthday: birthday.blank? ? Date.today.prev_year(15) : birthday, identity: identity.to_i)
    end
    true
  end

  def encrypted_password
    salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
    self.salt = salt_arr.sample(18).join
    self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
  end
end
