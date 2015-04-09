class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :place, foreign_key: :user_id


  TAGS = ['会员', '认证', '私教']
  BASE_NO = 10000
  mount_uploader :avatar, ProfileUploader

  class << self
    def find_by_mxid(mxid)
      find_by(id: mxid.to_i - BASE_NO)
    end
  end

  def age
    years = Date.today.year - birthday.year
    years + (Date.today < birthday + years.year ? -1 : 0)
  end

  def tags
    [rand(1), rand(1), identity.eql?(0) ? 0 : 1]
  end

  def mxid
    BASE_NO + id
  end

  def summary_json
    {
        mxid: mxid,
        name: name||'',
        avatar: $host + avatar.thumb.url,
        gender: gender,
        age: age,
        signature: signature,
        tags: tags
    }
  end


  def as_json
    {
        mxid: mxid,
        name: name,
        avatar: $host + avatar.thumb.url,
        signature: signature,
        gender: gender,
        identity: identity,
        age: age,
        address: address,

        target: target,
        skill: skill,
        often: often_stadium,
        interests: interests
    }
  end
end
