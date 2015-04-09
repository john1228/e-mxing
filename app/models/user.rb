class User < ActiveRecord::Base
  include UserConcern
  scope :fan, -> { where(id: Profile.where(identity: 0).pluck(:user_id)) }
  scope :coach, -> { where(id: Profile.where(identity: 1).pluck(:user_id)) }
  scope :service, -> { where(id: Profile.where(identity: 2).pluck(:user_id)) }
  validates_presence_of :username, message: '用户名不能为空'
  validates_uniqueness_of :username, message: '用戶已注册'

  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  attr_accessor :remote_avatar_url
  attr_accessor :name
  attr_accessor :gender
  attr_accessor :birthday
  attr_accessor :avatar
  attr_accessor :identity
  attr_accessor :mobile

  def token
    Digest::MD5.hexdigest("#{id}")
  end

  def mxid
    profile.mxid
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

end
