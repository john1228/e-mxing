class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :service_track, foreign_key: :track_id

  validates_uniqueness_of :track_id, scope: :user_id, message: '您已经预约过该团操'
end
