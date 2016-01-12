class Member < ActiveRecord::Base
  enum gender: [:male, :female]
  enum origin: [:mx, :input]
  enum member_type: [:associate, :full, :coach]

  belongs_to :coach
  validates_uniqueness_of :mobile, scope: :coach_id, message: '您已经添加该手机号为会员', if: coach?
  validates_uniqueness_of :mobile, scope: :service_id, message: "该会员已经创建在该店铺下", if: associate?||full?
  mount_uploader :avatar, ProfileUploader

  has_many :cards, class: MembershipCard
  belongs_to :user
end
