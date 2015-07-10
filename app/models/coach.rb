class Coach<User
  default_scope { joins(:profile).where('profiles.identity' => 1) }
  has_many :coach_docs, dependent: :destroy
  has_many :coach_dynamics, foreign_key: :user_id, dependent: :destroy
  has_many :coach_photos, foreign_key: :user_id, dependent: :destroy
  has_many :coach_tracks, foreign_key: :user_id, dependent: :destroy

  has_many :orders, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :appointment_settings, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :expiries, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates_uniqueness_of :mobile, message: '该手机号已经注册'

  def score
    comments = Comment.where(course_id: courses.pluck(:id))
    if comments.blank?
      {
          prof: 5,
          comm: 5,
          punc: 5,
          space: 5,
      }
    else
      {
          prof: (comments.average(:prof).to_f).round(1),
          comm: (comments.average(:comm).to_f).round(1),
          punc: (comments.average(:punc).to_f).round(1),
          space: (comments.average(:space).to_f).round(1),
      }
    end
  end
end