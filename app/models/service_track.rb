class ServiceTrack<Track
  belongs_to :service, foreign_key: :user_id
  has_many :appointments, foreign_key: :track_id, dependent: :destroy

  attr_accessor :dummy_start
end