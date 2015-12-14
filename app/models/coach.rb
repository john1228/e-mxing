class Coach<User
  default_scope { includes(:profile).where('profiles.identity' => 1) }
  scope :recommended, -> { joins(:recommend).order('recommends.id desc') }
  has_many :coach_docs, dependent: :destroy
  has_many :coach_dynamics, foreign_key: :user_id, dependent: :destroy
  has_many :coach_photos, foreign_key: :user_id, dependent: :destroy


  has_many :orders, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :lessons, dependent: :destroy

  has_one :service_member, dependent: :destroy
  has_one :service, through: :service_member
  has_one :recommend, -> { where(type: Recommend::TYPE[:person]) }, foreign_key: :recommended_id

  #V3
  has_many :members, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :clocks, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :mobile, message: '请填写手机号'
  validates_uniqueness_of :mobile, message: '该手机号已经注册'
  validates_format_of :mobile, with: /^(0|86|17951)?(13[0123456789]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/, multiline: true, message: '无效到手机号码'
  validates_presence_of :password, message: '请输入手机号码'

  def score
    score = if comments.blank?
              4
            else
              comments.average(:score)
            end
    score.round(1)
  end

  def detail
    {
        mxid: profile.mxid,
        name: HarmoniousDictionary.clean(profile.name),
        avatar: profile.avatar.url||'',
        gender: profile.gender||1,
        age: profile.age,
        photowall: photos.map { |photo| {url: photo.photo.url} },
        score: score,
        likes: likes.count,
        dynamics: dynamics.count,
        signature: profile.signature,
        service: {
            mxid: service.profile.mxid,
            name: service.profile.name,
            address: service.profile.address,
            coordinate: {
                lng: service.place.lonlat.x,
                lat: service.place.lonlat.y
            },
        },
        skill: skill,
        fpg: _fitness_program,
        course: {
            amount: Sku.online.where(seller_id: id).count,
            item: Sku.online.where(seller_id: id).order(updated_at: :desc).take(2)
        },
        comment: {
            amount: comments.count,
            item: comments.take(2)
        },
        contact: mobile
    }
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