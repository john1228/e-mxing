class Service<User
  default_scope { joins(:profile).where('profiles.identity' => 2) }
  has_many :service_members
  has_many :service_photos, foreign_key: :user_id
  has_many :service_tracks, foreign_key: :user_id
  has_many :service_dynamics, foreign_key: :user_id

  has_many :coaches, through: :service_members
  alias_attribute :hobby, :interests
end