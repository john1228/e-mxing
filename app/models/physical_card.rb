class PhysicalCard < ActiveRecord::Base
  validates :virtual_number, :entity_number, presence: true, uniqueness: true

end
