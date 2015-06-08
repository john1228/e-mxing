class Profile < ActiveRecord::Base
  include ProfileAble
  scope :enthusiasts, -> { where(identity: 0) }
  scope :gyms, -> { where(identity: 1) }
  scope :service, -> { where(identity: 2) }

  belongs_to :user
  has_one :place, through: :user
  alias_attribute :often, :often_stadium

  TAGS = %w(会员 认证 私教)
  BASE_NO = 10000
  mount_uploader :avatar, ProfileUploader

  class << self
    def find_by_mxid(mxid)
      find_by(id: mxid.to_i - BASE_NO)
    end
  end

  def age
    birth = birthday||Date.today.prev_year(15)
    years = Date.today.year - birth.year
    years + (Date.today < birth + years.year ? -1 : 0)
  end

  def interests_string
    interests_ary = interests.split(',')
    choose_interests = INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }
    choose_interests.collect { |choose| choose['name'] }.join(',')
  end

  def tags
    [0, identity.eql?(2) ? 1 : 0, identity.eql?(1) ? 1 : 0]
  end

  def mxid
    BASE_NO + id
  end

  def summary_json
    {
        mxid: mxid,
        name: name||'',
        avatar: avatar.thumb.url,
        gender: gender||1,
        age: age,
        signature: signature,
        tags: tags,
        identity: identity,
    }
  end


  def as_json
    {
        mxid: mxid,
        name: name||'',
        avatar: avatar.thumb.url,
        signature: signature,
        gender: gender||1,
        identity: identity,
        age: age,
        birthday: birthday,
        address: address,

        target: target,
        skill: skill,
        often: often_stadium,
        interests: interests,

        tags: tags
    }
  end
end
