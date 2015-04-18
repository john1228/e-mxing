class ServiceMember < ActiveRecord::Base
  belongs_to :service
  belongs_to :coach
  accepts_nested_attributes_for :coach, reject_if: :all_blank, allow_destroy: true
end
