class Like < ActiveRecord::Base
  validates_uniqueness_of :liked_id, scope: :user_id
  DYNAMIC = 1
  PERSON = 2
end
