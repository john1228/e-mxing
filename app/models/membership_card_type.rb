class MembershipCardType < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked]
  belongs_to :service

  def card_type_value
    MembershipCardType.card_types[card_type]
  end
end
