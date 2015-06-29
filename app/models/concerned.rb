class Concerned < ActiveRecord::Base
  belongs_to :course, counter_cache: true
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :course_id
end
