class Profile < ActiveRecord::Base
  belongs_to :user

  TAGS = ['会员', '认证', '私教']
  BASE_NO = 10000

  class << self
    def find_by_mxid(mxid)
      find_by(id: mxid.to_i - BASE_NO)
    end
  end

  mount_uploader :avatar, ProfileUploader

  def age
    years = Date.today.year - birthday.year
    years + (Date.today < birthday + years.year ? -1 : 0)
  end

  def tags
    [0, 0, 1]
  end

  def mxid
    BASE_NO + id
  end

  def summary_json
    {
        mxid: mxid,
        name: name,
        avatar: $host + avatar.thumb.url,
        gender: gender,
        age: age,
        tags: tags
    }
  end


  def as_json
    {
        mxid: mxid,
        name: name,
        avatar: {
            thumb: $host + avatar.thumb.url,
            original: $host + avatar.url
        },
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
