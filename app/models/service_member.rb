class ServiceMember < ActiveRecord::Base
  before_create :build_default_coach
  belongs_to :service
  belongs_to :coach, foreign_key: :user_id
  delegate :name, :avatar, :signature, to: :coach, allow_nil: false

  attr_accessor :member_username
  attr_accessor :member_password
  attr_accessor :member_name
  attr_accessor :member_avatar
  attr_accessor :member_signature
  attr_accessor :member_gender
  attr_accessor :member_birthday
  attr_accessor :member_address

  attr_accessor :member_target
  attr_accessor :member_skill
  attr_accessor :member_stadium
  attr_accessor :member_interests
  attr_accessor :member_identity

  private
  def build_default_coach
    create_coach(username: member_username, password: member_password, name: member_name, avatar: member_avatar,
                 signature: member_signature, gender: member_gender, birthday: member_birthday, address: member_address,
                 target: member_target, skill: member_skill, often: member_stadium, interests: member_interests,
                 identity: member_identity
    )
  end
end
