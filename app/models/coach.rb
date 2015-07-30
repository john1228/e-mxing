class Coach<User
  default_scope { joins(:profile).where('profiles.identity' => 1) }
  has_many :coach_docs, dependent: :destroy
  has_many :coach_dynamics, foreign_key: :user_id, dependent: :destroy
  has_many :coach_photos, foreign_key: :user_id, dependent: :destroy
  has_many :coach_tracks, foreign_key: :user_id, dependent: :destroy


  has_many :orders, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :lessons, dependent: :destroy

  has_one :service_member, dependent: :destroy
  has_one :service, through: :service_member
  validates_uniqueness_of :mobile, message: '该手机号已经注册'

  def score
    Comment.where(course_id: courses.pluck(:id)).average(:id)
  end

  def addresses
    if service.blank?
      []
    else
      [
          {
              id: service.profile.id,
              venus: service.profile.name,
              address: service.profile.address
          }
      ]
    end
  end
end