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
  has_many :likes, -> { where(like_type: Like::PERSON) }, foreign_key: :liked_id, dependent: :destroy

  attr_accessor :name, :avatar, :gender, :signature, :identity, :birthday, :address, :target, :skill, :often, :interests
  delegate :mxid, :name, :avatar, :age, :tags, :signature, :gender, :birthday, :identity, :address, :target, :skill, :often, :interests, :interests_string, to: :profile, prefix: true, allow_nil: false
  alias_attribute :hobby, :interests

  #v3
  has_one :wallet, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerns, class: Concerned, dependent: :destroy

  has_one :setting, dependent: :destroy


  # validates_uniqueness_of :sns, conditions: -> { where.not(sns: nil) },message: '该第三方已注册'
  # validates_uniqueness_of :mobile, conditions: -> { where.not(mobile: nil) },message: '该手机号已注册'
  # validates_presence_of :sns, unless: :mobile, message: '第三方不能为空'
  # validates_presence_of :mobile, unless: :sns, message: '手机号不能为空'


  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  class<<self
    def find_by_mxid(mxid)
      includes(:profile).where('profiles.id' => ((mxid.to_i - 10000))).first
    end
  end


  def token
    Digest::MD5.hexdigest("#{id}")
  end

  def summary_json
    regular = /^1[3|4|5|7|8][0-9]\d{4,8}$/
    if regular.match(mobile).blank?
      login_info = profile.summary_json.merge(mobile: '', token: token)
    else
      login_info = profile.summary_json.merge(mobile: mobile[0, 3]+'****'+ mobile[7, 4], token: token)
    end
    login_info
  end

  def as_json
    if profile.identity.eql?(0)
      profile.as_json.merge(likes: likes.count)
    else
      profile.as_json.merge(likes: likes.count, mobile: mobile||'')
    end
  end

end
