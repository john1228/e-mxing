class User < ActiveRecord::Base
  include UserAble
  has_one :profile, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :dynamics, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_one :place, dependent: :destroy
  has_one :showtime
  has_many :applies
  attr_accessor :name, :avatar, :gender, :signature, :identity, :birthday, :address, :target, :skill, :often, :interests
  delegate :mxid, :name, :avatar, :age, :tags, :signature, :gender, :birthday, :address, :target, :skill, :often, :interests, :interests_string, to: :profile, prefix: true, allow_nil: false
  alias_attribute :hobby, :interests
  has_many :likes, -> { where(like_type: Like::PERSON) }, foreign_key: :liked_id, dependent: :destroy


  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  class<<self
    def find_by_mxid(mxid)
      includes(:profile).where("profiles.id" => ((mxid.to_i - 10000))).first
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

  def as_json
    profile.as_json.merge(likes: likes.count)
  end
end
