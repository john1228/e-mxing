class MembershipCardType < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked]
  belongs_to :service
end
