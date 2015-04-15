class User < ActiveRecord::Base
  include UserAble
  validates_presence_of :username, message: '用户名不能为空'
  validates_uniqueness_of :username, message: '用戶已注册'

  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  attr_accessor :name
  attr_accessor :avatar
  attr_accessor :gender
  attr_accessor :signature
  attr_accessor :identity
  attr_accessor :birthday
  attr_accessor :address

  attr_accessor :target
  attr_accessor :skill
  attr_accessor :often
  attr_accessor :interests
  attr_accessor :mobile

  class<<self
    def find_by_mxid(mxid)
      includes(:profile).where("profiles.id" => ((mxid - 10000) rescue 0)).first
    end
  end


  def token
    Digest::MD5.hexdigest("#{id}")
  end

  def summary_json
    profile.summary_json.merge(token: token)
  end

end
