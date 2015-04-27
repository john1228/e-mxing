class Coach<User
  default_scope { joins(:profile).where('profiles.identity' => 1) }
  has_many :service_tracks
end