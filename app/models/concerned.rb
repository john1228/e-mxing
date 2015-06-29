class Concerned < ActiveRecord::Base
  belongs_to :course, counter_cache: :concerns_count
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :course_id
end
