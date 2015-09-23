class Coach<User
  default_scope { joins(:profile).where('profiles.identity' => 1) }
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
    if comments.blank?
      4
    else
      comments.average(:score)
    end
  end

  def comments
    sku_array = Sku.online.where('skus.sku LIKE ?', 'CC%').where(seller_id: id).pluck(:sku)
    Comment.where(sku: sku_array).order(id: :desc)
  end

  def detail
    detail = {
        mxid: profile.mxid,
        name: HarmoniousDictionary.clean(profile.name),
        avatar: {
            thumb: profile.avatar.thumb.url,
            origin: profile.avatar.url
        },
        tag: profile.tags,
        gender: profile.gender||1,
        age: profile.age,
        photowall: photos,
        score: score,
        likes: likes.count,
        dynamics: dynamics.count,
        signature: profile.signature,
        address: service.profile.address,
        coordinate: {
            lng: service.place.lonlat.x,
            lat: service.place.lonlat.y
        },
        service: {
            mxid: service.profile.mxid,
            name: service.profile.name,
        },
        skill: _skill,
        course: {
            amount: Sku.online.where('skus.sku LIKE ?', 'CC%').where(seller_id: id).count,
            item: Sku.online.where('skus.sku LIKE ?', 'CC%').where(seller_id: id).order(updated_at: :desc).take(2)
        },
        comment: {
            amount: comments.count,
            item: comments.take(2)
        },
        contact: mobile
    }

    detail = detail.merge(showtime: {
                              id: showtime.id,
                              cover: showtime.dynamic_film.cover.url,
                              film: showtime.dynamic_film.film.hls
                          }) if showtime.present?
    detail
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

  private
  def _skill
    interests_ary = profile.interests.split(',') rescue []
    choose_interests = INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }
    choose_interests.collect { |choose| choose['name'] }
  end
end