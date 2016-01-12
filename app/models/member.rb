class Member < ActiveRecord::Base
  enum gender: [:male, :female]
  enum origin: [:mx, :input]
  enum member_type: [:associate, :full, :coach]

  belongs_to :coach
  validates_uniqueness_of :mobile, scope: :coach_id, message: '您已经添加该手机号为会员', if: Proc.new { |member| member.coach? }
  mount_uploader :avatar, ProfileUploader

  has_many :cards, class: MembershipCard
  belongs_to :user
end
