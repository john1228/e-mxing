class Coach<User
  default_scope { joins(:profile, :service).where('profiles.identity' => 1) }
  scope :recommended, -> { joins(:recommend).order('recommends.id desc') }
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
  has_one :recommend, -> { where(type: Recommend::TYPE[:person]) }, foreign_key: :recommended_id
  validates_uniqueness_of :mobile, message: '该手机号已经注册'

  def score
    sku_array = courses.pluck(:id).map { |id| 'CC' + '-' + '%06d' % id + '-' + '%06d' % (service.id) }
    Comment.where(sku: sku_array).average(:score)
  end

  def comments
    sku_array = courses.pluck(:id).map { |id| 'CC' + '-' + '%06d' % id + '-' + '%06d' % (service.id) }
    Comment.where(sku: sku_array)
  end

  def addresses
    if service.blank?
      []
    else
      [
          {
              id: service.profile.id,
              venues: service.profile.name,
              address: service.profile.address
          }
      ]
    end
  end
end