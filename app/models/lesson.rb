class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  has_many :appointments
  scope :available, -> { where('available > used') }
  scope :expired, -> { where('exp<?', Date.today) }
end
