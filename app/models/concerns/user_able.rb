module UserAble
  extend ActiveSupport::Concern
  included do
    before_create :build_default_profile
    before_save :encrypted_password
    after_update :update_profile

    has_one :profile, dependent: :destroy
    delegate :mxid, :name, :avatar, :signature, :gender, :birthday, :address, :target, :skill, :often, :interests, to: :profile, prefix: true, allow_nil: false

    has_many :photos, dependent: :destroy
    has_many :dynamics, dependent: :destroy
    has_many :dynamic_comments, dependent: :destroy
    has_many :tracks, dependent: :destroy
    has_many :group_members, dependent: :destroy
    has_many :appointments, dependent: :destroy
    has_one :place, dependent: :destroy
    has_many :service_members, dependent: :destroy

    attr_accessor :name, :avatar, :gender, :signature, :identity, :birthday, :address, :target, :skill, :often, :interests, :mobile
  end

  private
  def build_default_profile
    if avatar.is_a?(String)
      build_profile(name: name,
                    remote_avatar_url: avatar,
                    gender: gender,
                    signature: signature||'这家伙很懒,什么也没留下',
                    identity: identity||0,
                    birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                    address: address||'',
                    target: target||'',
                    skill: skill||'',
                    often: often||'',
                    interests: interests||'',
                    mobile: mobile||'')
    else
      build_profile(name: name,
                    avatar: avatar,
                    gender: gender,
                    signature: signature||'这家伙很懒,什么也没留下',
                    identity: identity||0,
                    birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                    address: address||'',
                    target: target||'',
                    skill: skill||'',
                    often: often||'',
                    interests: interests||'',
                    mobile: mobile||'')
    end
    true
  end

  def encrypted_password
    salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
    self.salt = salt_arr.sample(18).join
    self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
  end

  def update_profile
    profile.update(name: name,
                   avatar: avatar,
                   gender: gender,
                   signature: signature||'这家伙很懒,什么也没留下',
                   identity: identity||0,
                   birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                   address: address||'',
                   target: target||'',
                   skill: skill||'',
                   often: often||'',
                   interests: interests||'',
                   mobile: mobile||'')
  end
end