class Coach<User
  default_scope { joins(:profile).where('profiles.identity' => 1) }
  has_many :coach_docs, dependent: :destroy
  has_many :coach_dynamics, foreign_key: :user_id, dependent: :destroy
  has_many :coach_photos, foreign_key: :user_id, dependent: :destroy
  has_many :coach_tracks, foreign_key: :user_id, dependent: :destroy

  has_many :courses, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :appointment_settings, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :expiries, dependent: :destroy

  validates_uniqueness_of :mobile, message: '该手机号已经注册'
end