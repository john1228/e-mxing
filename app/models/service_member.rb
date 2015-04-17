class ServiceMember < ActiveRecord::Base
  before_create :build_default_coach
  belongs_to :service
  belongs_to :coach, foreign_key: :user_id
  delegate :name, :avatar, :signature, to: :coach, allow_nil: false
  validates_presence_of :user_id, message: '创建私教失败'


  attr_accessor :member_username, :member_password, :member_name, :member_avatar, :member_signature, :member_gender, :member_birthday,
                :member_address, :member_target, :member_skill, :member_stadium, :member_interests, :member_identity

  private
  def build_default_coach
    create_coach(username: member_username, password: member_password, name: member_name, avatar: member_avatar,
                 signature: member_signature, gender: member_gender, birthday: member_birthday, address: member_address,
                 target: member_target, skill: member_skill, often: member_stadium, interests: member_interests,
                 identity: member_identity)
  end
end
