class MembershipCardType < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked, :course]
  belongs_to :service
  has_many :products, dependent: :destroy, foreign_key: :card_type_id

  validates :name, :service_id, :card_type, :price, :value, presence: true

  def card_type_value
    MembershipCardType.card_types[card_type]
  end
end
