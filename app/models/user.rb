class User < ActiveRecord::Base
  include UserAble
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
    if mobile.present? && mobile.start_with?("1")
      profile.summary_json.merge(mobile: (mobile[0, 3]+"****"+ mobile[7, 4] rescue ''), token: token)
    else
      profile.summary_json.merge(mobile: '', token: token)
    end
  end

end
