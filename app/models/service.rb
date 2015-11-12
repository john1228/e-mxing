class Service<User
  default_scope { joins(:profile).where('profiles.identity' => 2) }
  scope :authorized, -> { where(profiles: {auth: 1}) }
  scope :unauthorized, -> { where(profiles: {auth: 0}) }

  after_save :location
  has_many :service_members, dependent: :destroy
  has_many :service_photos, foreign_key: :user_id, dependent: :destroy
  has_many :service_dynamics, foreign_key: :user_id, dependent: :destroy

  has_many :service_members, dependent: :destroy
  has_many :coaches, through: :service_members

  has_many :courses, class_name: Sku

  alias_attribute :service_id, :id

  def as_json
    in_the_sale = Sku.online.where(service_id: id)
    top_sellers = in_the_sale.where('skus.sku LIKE ?', 'CC%').order(orders_count: :desc).order(id: :asc).pluck(:seller_id).uniq[0, 3]
    tops = coaches.where(id: top_sellers)
    tops += coaches.where.not(id: top_sellers).order(id: :desc).take(3-tops.length) unless tops.length.eql?(3)
    {
        mxid: profile.mxid,
        name: profile.name,
        avatar: profile.avatar.url,
        address: profile.province.to_s + profile.city.to_s + profile.address.to_s,
        background: (photos.first.photo.url rescue ''),
        distance: (attributes['distance']||0).to_i,
        coach: {
            amount: coaches.count,
            top: tops.map { |top| top.summary_json }
        },
        sale: {
            amount: in_the_sale.count,
            sold: in_the_sale.sum(:orders_count),
            floor_price: (in_the_sale.order(selling_price: :asc).first.selling_price.to_i rescue 0)
        }
    }
  end

  def detail
    in_the_sale = Sku.online.where(seller_id: coaches.pluck(:id)<<id)
    {
        mxid: profile.mxid,
        name: profile.name,
        avatar: {
            thumb: profile.avatar.url,
            origin: profile.avatar.url
        },
        views: views,
        address: profile.address,
        coordinate: {
            lng: place.lonlat.x,
            lat: place.lonlat.y
        },
        intro: profile.signature,
        coach: {
            amount: coaches.count,
            item: coaches.map { |coach| coach.summary_json.merge(
                likes: coach.likes.count
            ) }
        },
        dynamics: dynamics.count,
        course: {
            amount: in_the_sale.count,
            item: in_the_sale.order(updated_at: :desc).take(2)
        },
        open: '8:30-21:30',
        service: profile._fitness_program,
        facility: profile.service,
        contact: profile.mobile,
        photowall: photos.map { |photo| {url: photo.photo.url} }
    }
  end

  private

  def location
    if profile.changed?
      conn = Faraday.new(:url => 'http://api.map.baidu.com')
      address_summary = ((profile.province.to_s + profile.city.to_s + profile.address.to_s).match(/(.+?)[弄号]/)).to_s
      result = conn.get '/geocoder/v2/', address: address_summary, output: 'json', ak: '61Vl2dO7CKCt0rvLKQiePGT5'
      json_string = JSON.parse(result.body)
      bd_lng = json_string['result']['location']['lng']
      bd_lat = json_string['result']['location']['lat']
      if place.nil?
        create_place(lonlat: "POINT(#{bd_lng} #{bd_lat})")
      else
        place.update(lonlat: "POINT(#{bd_lng} #{bd_lat})")
      end
      #更新机构课程课程的地址
      Sku.where(service_id: id).update_all(address: profile.province.to_s + profile.city.to_s + profile.address.to_s, coordinate: gcj_02(bd_lng, bd_lat))
    end
  end
end
