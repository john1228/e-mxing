class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  scope :available, -> { where('available > used') }
  scope :exp, -> { where('exp<?', Date.today) }
end
