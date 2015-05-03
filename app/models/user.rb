class User < ActiveRecord::Base
  include UserAble
  validates_presence_of :username, message: '用户名不能为空'
  validates_uniqueness_of :username, message: '用戶已注册'

  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]


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
    profile.summary_json.merge(mobile: (mobile[0, 3]+"****"+ mobile[7, 4] rescue ''))
  end

end
