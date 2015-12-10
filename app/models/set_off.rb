class SetOff < ActiveRecord::Base
  belongs_to :coach
  validates :coach_id, :start, :end, :repeat, :week, presence: true
end
