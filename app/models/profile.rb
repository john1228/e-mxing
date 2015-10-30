class Profile < ActiveRecord::Base
  include ProfileAble
  enum identity: [:enthusiast, :gyms, :service]
  belongs_to :user
  has_one :place, through: :user
  alias_attribute :often, :often_stadium
  validates_presence_of :name, if: Proc.new { |profile| profile.service? }, message: '名字不能为空'
  validates_presence_of :avatar, if: Proc.new { |profile| profile.service? }, message: '头像不能为空'
  validates_presence_of :signature, if: Proc.new { |profile| profile.service? }, message: '介绍不能为空'
  validates_presence_of :province, if: Proc.new { |profile| profile.service? }, message: '省份不能为空'
  validates_presence_of :city, if: Proc.new { |profile| profile.service? }, message: '城市不能为空'
  validates_presence_of :address, if: Proc.new { |profile| profile.service? }, message: '详细地址不能为空'
  validates_presence_of :hobby, if: Proc.new { |profile| profile.service? }, message: '服务项目不能为空'
  validates_presence_of :mobile, if: Proc.new { |profile| profile.service? }, message: '联系电话不能为空'

  validates_presence_of :name, if: Proc.new { |profile| profile.gyms? }, message: '名字不能为空'
  validates_presence_of :avatar, if: Proc.new { |profile| profile.gyms? }, message: '头像不能为空'
  validates_presence_of :birthday, if: Proc.new { |profile| profile.gyms? }, message: '生日不能为空'
  validates_presence_of :gender, if: Proc.new { |profile| profile.gyms? }, message: '性别不能为空'
  validates_presence_of :hobby, if: Proc.new { |profile| profile.gyms? }, message: '健身服务不能为空'

  TAGS = %w(会员 认证 私教)
  BASE_NO = 10000
  mount_uploader :avatar, ProfileUploader

  class << self
    def find_by_mxid(mxid)
      find_by(id: mxid.to_i - BASE_NO)
    end
  end

  def age
    if birthday.blank?
      0
    else
      years = Date.today.year - birthday.year
      years + (Date.today < birthday + years.year ? -1 : 0)
    end
  end

  def interests_string
    choose_interests = INTERESTS['items'].select { |item| hobby.include?(item['id']) }
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
        name: HarmoniousDictionary.clean(name||''),
        avatar: avatar.url,
        gender: gender||1,
        age: age.eql?(0) ? 16 : age,
        true_age: age,
        signature: HarmoniousDictionary.clean(signature),
        tags: tags,
        identity: identity
    }
  end


  def as_json
    {
        mxid: mxid,
        name: name||'',
        avatar: avatar.url,
        signature: HarmoniousDictionary.clean(signature),
        gender: gender||1,
        identity: identity,
        age: age.eql?(0) ? 16 : age,
        true_age: age,
        birthday: birthday||Date.today.prev_year(16),
        address: address,

        target: HarmoniousDictionary.clean(target),
        skill: skill,
        often: HarmoniousDictionary.clean(often_stadium),
        interests: interests,

        tags: tags
    }
  end
end
