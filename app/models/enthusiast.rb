class Enthusiast<User
  default_scope { joins(:profile).where('profiles.identity' => 0) }
end