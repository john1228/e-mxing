class User < ActiveRecord::Base
  include UserAble
  default_scope { joins(:profile).where('profiles.identity' => 0) }
  validates_presence_of :username, message: '用户名不能为空'
  validates_uniqueness_of :username, message: '用戶已注册'

  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  attr_accessor :remote_avatar_url
  attr_accessor :name
  attr_accessor :gender
  attr_accessor :birthday
  attr_accessor :avatar
  attr_accessor :mobile
  attr_accessor :identity


  def token
    Digest::MD5.hexdigest("#{id}")
  end

  def summary_json
    profile.summary_json.merge(token: token)
  end

end
