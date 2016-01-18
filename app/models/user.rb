class User < ActiveRecord::Base
  has_one :profile, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :dynamics, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_one :place, dependent: :destroy
  has_many :applies
  has_many :likes, -> { where(like_type: Like.like_types[:person]) }, foreign_key: :liked_id, dependent: :destroy
  has_many :liked, class: Like, dependent: :destroy
  attr_accessor :new
  #v3
  has_one :wallet, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerns, class_name: Concerned, dependent: :destroy
  has_one :setting, dependent: :destroy
  accepts_nested_attributes_for :profile
  #membershipcards
  has_many :members, dependent: :destroy
  has_many :cards, class: MembershipCard, through: :members
  before_create :build_default_wallet

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
    login_info.merge(new: new.present? ? 1 : 0)
  end

  def as_json
    case profile.identity
      when 'enthusiast'
        profile.as_json.merge(likes: likes.count)
      when 'coach'
        profile.as_json.merge(likes: likes.count, mobile: mobile)
      when 'service'
        profile.as_json.merge(likes: likes.count, mobile: profile.mobile)
      else
    end
  end

  before_save :encrypted_password
  private
  def encrypted_password
    unless password_was.eql?(password)
      salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
      self.salt = salt_arr.sample(18).join
      self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
    end
  end

  def build_default_wallet
    build_wallet
    true
  end
end
