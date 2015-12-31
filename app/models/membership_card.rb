class MembershipCard < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked, :coach]
  belongs_to :member
  has_many :logs, class: MembershipCardLog, dependent: :destroy
end
