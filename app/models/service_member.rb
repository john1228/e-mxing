class ServiceMember < ActiveRecord::Base
  before_create :build_default_member
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

  private
  def build_default_member
    create_member(username: member_username, password: member_password, name: member_name, avatar: member_avatar, identity: 1)
  end
end
